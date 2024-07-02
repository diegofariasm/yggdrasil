use std::path::PathBuf;

use image::{GenericImageView, Pixel};
use serde::{Deserialize, Serialize};
use strum::{Display, EnumString};
use zvariant::Type;

#[derive(Deserialize, Serialize, EnumString, Display, Type, Debug, PartialEq, Eq, Clone, Hash)]
pub enum Luminance {
    Dark,
    Light,
}

impl AsRef<str> for Luminance {
    fn as_ref(&self) -> &str {
        match self {
            Self::Light => "Light",
            Self::Dark => "Dark",
        }
    }
}

impl From<Luminance> for &'static str {
    fn from(d: Luminance) -> Self {
        match d {
            Luminance::Light => "Light",
            Luminance::Dark => "Dark",
        }
    }
}

impl Luminance {
    pub fn from_image(image_path: PathBuf) -> Result<Luminance, image::ImageError> {
        let img = image::open(image_path)?;

        let mut total_brightness = 0.0;
        let mut pixel_count = 0;

        for (_, _, pixel) in img.pixels() {
            let rgb = pixel.to_rgb();
            let r = rgb[0] as f32;
            let g = rgb[1] as f32;
            let b = rgb[2] as f32;

            let brightness = (r + g + b) / 3.0;
            total_brightness += brightness;
            pixel_count += 1;
        }

        let avg_brightness = total_brightness / pixel_count as f32;

        let is_dark_mode = avg_brightness < 128.0;

        if is_dark_mode {
            return Ok(Luminance::Dark);
        }
        return Ok(Luminance::Light);
    }
}
