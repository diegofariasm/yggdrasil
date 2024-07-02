#![allow(unknown_lints)]
#![allow(clippy)]
#![allow(warnings)]
pub use protocols::*;

pub mod protocols {
    use wayland_client;
    use wayland_client::protocol::*;

    pub mod __interfaces {
        use wayland_client::protocol::__interfaces::*;
        wayland_scanner::generate_interfaces!("./protocol/river-status-unstable-v1.xml");
    }
    use self::__interfaces::*;

    wayland_scanner::generate_client_code!("./protocol/river-status-unstable-v1.xml");
}
