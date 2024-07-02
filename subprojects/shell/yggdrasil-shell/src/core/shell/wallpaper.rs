use crate::{core::luminance::Luminance, utils::path_includes_folder};
use allmytoes::{AMTConfiguration, ThumbSize, AMT};
use infer::MatcherType;
use serde::{Deserialize, Serialize};
use std::{path::PathBuf, sync::Arc};
use tokio::task;
use walkdir::WalkDir;

#[derive(Serialize, Deserialize, Debug, Clone, Hash, PartialEq, Eq)]
pub struct Wallpaper {
    pub path: PathBuf,
    pub thumbnail: PathBuf,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct Wallpapers {
    pub directory: PathBuf,
}

impl Wallpapers {
    pub async fn new(directory: PathBuf) -> Self {
        Self { directory }
    }
}

pub async fn get_by_luminance(
    wallpapers: Vec<Arc<Wallpaper>>,
    luminance: Luminance,
) -> Vec<Arc<Wallpaper>> {
    let mut tasks = vec![];
    let ignored_folders = vec!["dark", "light", "follows-scheme"];

    for wallpaper in wallpapers.clone() {
        for ignored_folder in &ignored_folders {
            if path_includes_folder(&wallpaper.path, ignored_folder) {
                continue;
            }
        }

        tasks.push(task::spawn(async move {
            let wallpaper_luminance = Luminance::from_image(wallpaper.path.clone())
                .expect("Failed to get luminance from image");

            (wallpaper, wallpaper_luminance)
        }));
    }

    let mut luminance_wallpapers = Vec::new();

    for task in tasks {
        if let Ok((wallpaper, wallpaper_luminance)) = task.await {
            if wallpaper_luminance == luminance {
                luminance_wallpapers.push(wallpaper.clone());
            }
        }
    }

    luminance_wallpapers
}

async fn generate_thumbnail(path: &PathBuf) -> PathBuf {
    // The configuration for allmytoes
    // Usually, the defaults are fine.
    let configuration = AMTConfiguration::default();

    let amt = AMT::new(&configuration);
    let thumb_size = ThumbSize::Large;

    let thumbnail = match amt.get(path, thumb_size) {
        Ok(thumb) => {
            let thumbnail = PathBuf::from(thumb.path);

            thumbnail
        }
        Err(error) => {
            // TODO: better handling of this
            panic!(
                "Error '{:?}' occurred when trying to provide the thumb. ({})",
                error,
                error.msg(),
            );
        }
    };
    thumbnail
}

pub async fn scan(directory: &PathBuf) -> Vec<Wallpaper> {
    let mut tasks = vec![];
    for entry in WalkDir::new(directory) {
        let entry = entry.unwrap();
        if entry.file_type().is_file() {
            let path = entry.path().to_path_buf();

            let kind = infer::get_from_path(&path)
                .expect("file read successfully")
                .expect("file type is known");

            let matcher_type = kind.matcher_type();

            if matcher_type == MatcherType::Image {
                tasks.push(task::spawn(async move {
                    let thumbnail = generate_thumbnail(&path).await;
                    Wallpaper { path, thumbnail }
                }));
            }
        }
    }

    let mut wallpapers = Vec::new();

    for task in tasks {
        if let Ok(wallpaper) = task.await {
            wallpapers.push(wallpaper);
        }
    }
    wallpapers
}
