use directories::BaseDirs;
use event_listener::Listener;
use std::{error::Error, future::pending};
use yggdrasil_shell::core::services::wallpaper::WallpaperService;
use zbus::connection;

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    let home_dir = match BaseDirs::new() {
        Some(base_dirs) => base_dirs.home_dir().to_path_buf(),
        None => {
            panic!("Could not find home directory");
        }
    };

    let yggdrasil_path = home_dir.join(".yggdrasil");
    let yggdrasil_wallpapers_path = yggdrasil_path.join("wallpaper");

    let wallpaper = WallpaperService {
        directory: yggdrasil_wallpapers_path,
        is_sorting: false,
        done: event_listener::Event::new(),
    };

    let done_listener = wallpaper.done.listen();

    let _conn = connection::Builder::session()?
        .name("yggdrasil.shell.wallpaper")?
        .serve_at("/yggdrasil/shell/wallpaper", wallpaper)?
        .build()
        .await?;

    done_listener.wait();

    // Do other things or go to wait forever
    pending::<()>().await;

    Ok(())
}
