use crate::core::{
    luminance::Luminance,
    shell::wallpaper::{get_by_luminance, scan, Wallpaper},
};
use event_listener::Event;
use serde_json::json;
use std::{path::PathBuf, sync::Arc};
use zbus::{fdo, interface, object_server::SignalContext, Result};

pub struct WallpaperService {
    pub directory: PathBuf,
    pub is_sorting: bool,
    pub done: Event,
}

#[interface(name = "yggdrasil.shell.wallpaper")]
impl WallpaperService {
    async fn query(&self, luminance: Luminance) -> String {
        let wallpapers = scan(&self.directory).await;
        let arc_wallpapers: Vec<Arc<Wallpaper>> = wallpapers.into_iter().map(Arc::new).collect();
        let luminance_wallpapers = get_by_luminance(arc_wallpapers, luminance).await;

        let json_wallpapers = json!({
            "wallpapers": luminance_wallpapers
        });

        let json_str = serde_json::to_string(&json_wallpapers).unwrap();

        json_str
    }

    async fn get_dark(&self) -> String {
        let all_wallpapers: Vec<Wallpaper> = scan(&self.directory.join("all")).await;
        let dark_wallpapers: Vec<Wallpaper> = scan(&self.directory.join("dark")).await;

        let arc_all_wallpapers: Vec<Arc<Wallpaper>> =
            all_wallpapers.into_iter().map(Arc::new).collect();

        let luminance_wallpapers: Vec<Arc<Wallpaper>> =
            get_by_luminance(arc_all_wallpapers, Luminance::Dark).await;

        let arc_dark_wallpapers: Vec<Arc<Wallpaper>> =
            dark_wallpapers.into_iter().map(Arc::new).collect();
        let mut merged: Vec<Arc<Wallpaper>> = luminance_wallpapers;
        merged.extend(arc_dark_wallpapers);

        let json_wallpapers = json!({
            "wallpapers": merged
        });

        let json_str = serde_json::to_string(&json_wallpapers).unwrap();

        json_str
    }

    async fn get_light(&self) -> String {
        let all_wallpapers: Vec<Wallpaper> = scan(&self.directory.join("all")).await;
        let light_wallpapers: Vec<Wallpaper> = scan(&self.directory.join("light")).await;

        let arc_all_wallpapers: Vec<Arc<Wallpaper>> =
            all_wallpapers.into_iter().map(Arc::new).collect();

        let luminance_wallpapers: Vec<Arc<Wallpaper>> =
            get_by_luminance(arc_all_wallpapers, Luminance::Light).await;

        let arc_light_wallpapers: Vec<Arc<Wallpaper>> =
            light_wallpapers.into_iter().map(Arc::new).collect();
        let mut merged: Vec<Arc<Wallpaper>> = luminance_wallpapers;
        merged.extend(arc_light_wallpapers);

        let json_wallpapers = json!({
            "wallpapers": merged
        });

        let json_str = serde_json::to_string(&json_wallpapers).unwrap();

        json_str
    }

    async fn get(&self) -> String {
        let wallpapers = scan(&self.directory).await;

        let json_wallpapers = json!({
            "wallpapers": wallpapers
        });

        let json_str = serde_json::to_string(&json_wallpapers).unwrap();

        json_str
    }

    #[zbus(property)]
    async fn is_sorting(&self) -> &bool {
        &self.is_sorting
    }

    /// A signal; the implementation is provided by the macro.
    #[zbus(signal)]
    async fn sorted(ctxt: &SignalContext<'_>) -> Result<()>;
    /// A signal; the implementation is provided by the macro.
    async fn send_sorted(
        &self,
        #[zbus(signal_context)] ctxt: SignalContext<'_>,
    ) -> fdo::Result<()> {
        Self::sorted(&ctxt).await?;
        self.done.notify(1);

        Ok(())
    }

    async fn sort(&mut self) -> fdo::Result<()> {
        if self.is_sorting {
            return Err(zbus::fdo::Error::Failed(
                "There is already a sorting event ongoing.".to_string(),
            ));
        }
        self.is_sorting = true;

        let wallpapers = scan(&self.directory.join("all")).await;

        let arc_wallpapers: Vec<Arc<Wallpaper>> = wallpapers.into_iter().map(Arc::new).collect();

        let light_wallpapers = get_by_luminance(arc_wallpapers.clone(), Luminance::Light).await;
        let dark_wallpapers = get_by_luminance(arc_wallpapers, Luminance::Dark).await;

        for light_wallpaper in light_wallpapers {
            let light_path = self
                .directory
                .join("light")
                .join(light_wallpaper.path.file_name().unwrap());

            std::fs::rename(&light_wallpaper.path, &light_path).expect("Failed to move wallpaper");
        }

        for dark_wallpaper in dark_wallpapers {
            let dark_path = self
                .directory
                .join("dark")
                .join(dark_wallpaper.path.file_name().unwrap());

            std::fs::rename(&dark_wallpaper.path, &dark_path).expect("Failed to move wallpaper");
        }
        // We are done sorting
        self.is_sorting = false;

        Ok(())
    }
}
