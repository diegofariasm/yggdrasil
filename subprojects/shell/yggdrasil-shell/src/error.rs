#[derive(Debug)]
#[non_exhaustive]
/// The error type for ashpd.
pub enum Error {
    /// Failed to parse a string into an enum variant
    ParseError(&'static str),
}
