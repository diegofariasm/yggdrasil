use std::path::{Component, PathBuf};

use walkdir::DirEntry;

/// Helper function to check if a path includes a specific folder.
pub fn path_includes_folder(path: &PathBuf, folder_name: &str) -> bool {
    path.components().any(|c| match c {
        Component::Normal(c) if c == folder_name => true,
        _ => false,
    })
}

pub fn is_hidden(entry: &DirEntry) -> bool {
    entry
        .file_name()
        .to_str()
        .map(|s| s.starts_with("."))
        .unwrap_or(false)
}
