use clap::{Parser, Subcommand, ValueEnum};

#[derive(Parser)]
#[command(version, about, long_about = None, subcommand_required = true)]
pub struct Cli {
    #[command(subcommand)]
    pub command: Option<Commands>,
}

#[derive(Subcommand)]
pub enum Commands {
    /// Command to query information about the river window manager.
    River(River),

    Wallpaper(Wallpaper),
}

/// Struct representing the River subcommand.
#[derive(Parser)]
pub struct Wallpaper {
    #[command(subcommand)]
    pub command: Option<WallpaperCommands>,

    #[arg(long, short)]
    pub luminance: Option<Luminance>,
}

#[derive(Subcommand)]
pub enum WallpaperCommands {
    /// Sorts wallpapers based on luminance.
    ///
    /// This command retrieves images from the 'all' folder located at yggdrasil.wallpapers.directory
    /// and categorizes them into 'dark' and 'light' luminance folders accordingly.
    Sort,
}

#[derive(ValueEnum, Clone)]
pub enum Luminance {
    Dark,
    Light,
}

#[derive(Parser)]
pub struct River {
    #[arg(long, short, global = true)]
    pub listen: bool,

    /// The specific command to execute within the River subcommand.
    #[command(subcommand)]
    pub command: Option<RiverCommands>,
}

#[derive(Subcommand)]
pub enum RiverCommands {
    Tags,
    Layout,
    Active,
}
