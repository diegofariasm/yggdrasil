use std::io::Result;
fn main() -> Result<()> {
    prost_build::compile_protos(
        &["proto/wallpaper.proto", "proto/luminance.proto"],
        &["proto/"],
    )?;
    Ok(())
}
