use clap::Parser;
use serde::{Deserialize, Serialize};
use serde_json::json;
use std::{collections::HashSet, process::ExitCode, thread::sleep, time::Duration};
use wayland_client::{
    protocol::{
        wl_output::{self, WlOutput},
        wl_registry,
        wl_registry::WlRegistry,
        wl_seat::{self, WlSeat},
    },
    {Dispatch, QueueHandle}, {EventQueue, Proxy},
};
use yggdrasil::cli::{Cli, Commands, Luminance, RiverCommands, WallpaperCommands};
use yggdrasil::protocols::{
    protocols::zriver_status_manager_v1::{self, ZriverStatusManagerV1},
    zriver_output_status_v1::{self, ZriverOutputStatusV1},
    zriver_seat_status_v1::{self, ZriverSeatStatusV1},
};

struct State {
    status_manager: Option<ZriverStatusManagerV1>,
    tags: Option<Vec<u32>>,
    focused_tags: Option<u32>,
    layout: Option<String>,
}

impl Dispatch<ZriverSeatStatusV1, ()> for State {
    fn event(
        _state: &mut Self,
        _seat_status: &ZriverSeatStatusV1,
        _event: zriver_seat_status_v1::Event,
        _: &(),
        _conn: &wayland_client::Connection,
        _qh: &QueueHandle<State>,
    ) {
    }
}

impl Dispatch<ZriverOutputStatusV1, ()> for State {
    fn event(
        state: &mut Self,
        _output_status: &ZriverOutputStatusV1,
        event: zriver_output_status_v1::Event,
        _: &(),
        _conn: &wayland_client::Connection,
        _qh: &QueueHandle<State>,
    ) {
        match event {
            zriver_output_status_v1::Event::LayoutName { name } => {
                state.layout = Some(name);
            }
            zriver_output_status_v1::Event::FocusedTags { tags } => {
                let focused_tag = tags.trailing_zeros() + 1; // Find the position of the bit and convert to 1-based index
                state.focused_tags = Some(focused_tag);
            }
            zriver_output_status_v1::Event::ViewTags { tags } => {
                let tags: Vec<u32> = tags[0..]
                    .chunks(4)
                    .map(|s| {
                        let buf = [s[0], s[1], s[2], s[3]];
                        let tagmask = u32::from_le_bytes(buf);
                        for i in 0..32 {
                            if 1 << i == tagmask {
                                return 1 + i;
                            }
                        }
                        0
                    })
                    .collect();

                state.tags = Some(tags);
            }
            _ => {}
        }
    }
}

impl Dispatch<WlRegistry, ()> for State {
    fn event(
        state: &mut Self,
        registry: &WlRegistry,
        event: wl_registry::Event,
        _: &(),
        _conn: &wayland_client::Connection,
        qh: &QueueHandle<State>,
    ) {
        if let wl_registry::Event::Global {
            name,
            interface,
            version,
        } = event
        {
            if interface == ZriverStatusManagerV1::interface().name {
                let status_manager: ZriverStatusManagerV1 = registry.bind(name, version, qh, ());
                state.status_manager = Some(status_manager);
            } else if interface == WlSeat::interface().name {
                registry.bind::<WlSeat, _, _>(name, version, qh, ());
            } else if interface == WlOutput::interface().name {
                registry.bind::<WlOutput, _, _>(name, version, qh, ());
            }
        }
    }
}

impl Dispatch<WlOutput, ()> for State {
    fn event(
        state: &mut Self,
        output: &WlOutput,
        _event: wl_output::Event,
        _: &(),
        _conn: &wayland_client::Connection,
        qh: &QueueHandle<State>,
    ) {
        if let Some(status_manager) = &state.status_manager {
            status_manager.get_river_output_status(output, qh, ());
        }
    }
}

impl Dispatch<WlSeat, ()> for State {
    fn event(
        state: &mut Self,
        seat: &WlSeat,
        _event: wl_seat::Event,
        _: &(),
        _conn: &wayland_client::Connection,
        qh: &QueueHandle<State>,
    ) {
        if let Some(status_manager) = &state.status_manager {
            status_manager.get_river_seat_status(seat, qh, ());
        }
    }
}

impl Dispatch<ZriverStatusManagerV1, ()> for State {
    fn event(
        _state: &mut Self,
        _status_manager: &ZriverStatusManagerV1,
        _event: zriver_status_manager_v1::Event,
        _data: &(),
        _conn: &wayland_client::Connection,
        _qh: &QueueHandle<State>,
    ) {
    }
}

#[derive(Serialize, Deserialize)]
struct Tag {
    id: u32,
    empty: bool,
}

#[derive(Serialize, Deserialize)]
struct RiverState {
    active: u32,
    active_empty: bool,
    layout: String,
    tags: Vec<Tag>,
}

use zbus::{proxy, Result};
#[proxy(
    interface = "yggdrasil.shell.wallpaper",
    default_service = "yggdrasil.shell.wallpaper",
    default_path = "/yggdrasil/shell/wallpaper"
)]
trait WallpaperService {
    async fn get(&self) -> Result<String>;

    async fn get_dark(&self) -> Result<String>;

    async fn get_light(&self) -> Result<String>;

    async fn get_all(&self) -> Result<String>;

    async fn sort(&self) -> Result<()>;
}

#[tokio::main]
async fn main() -> Result<ExitCode> {
    let connection = zbus::Connection::session().await?;
    let proxy = WallpaperServiceProxy::new(&connection).await?;
    let cli = Cli::parse();

    match &cli.command {
        Some(Commands::River(river)) => {
            let conn = wayland_client::Connection::connect_to_env().unwrap();
            let display = conn.display();
            let mut event_queue: EventQueue<State> = conn.new_event_queue();
            let qh = event_queue.handle();
            let mut state = State {
                status_manager: None,
                tags: None,
                focused_tags: None,
                layout: None,
            };
            let _registry = display.get_registry(&qh, ());

            loop {
                match event_queue.roundtrip(&mut state) {
                    Ok(num_events) => {
                        if num_events == 0 {
                            break;
                        }
                    }
                    Err(err) => {
                        eprintln!("Error dispatching events: {:?}", err);
                        break;
                    }
                }
            }

            let active = state.focused_tags.unwrap();
            let mut active_empty = true;

            let filled_tags = if let Some(tags) = &state.tags {
                if tags.contains(&active) {
                    active_empty = false;
                }
                if let Some(&max_tag) = tags.iter().max() {
                    let occupied_tags: HashSet<u32> = tags.iter().copied().collect();
                    (1..=max_tag)
                        .map(|id| Tag {
                            id,
                            empty: !occupied_tags.contains(&id),
                        })
                        .collect()
                } else {
                    Vec::new()
                }
            } else {
                Vec::new()
            };

            let river_state = RiverState {
                layout: state.layout.clone().unwrap(),
                tags: filled_tags,
                active: active,
                active_empty: active_empty,
            };

            match &river.command {
                Some(RiverCommands::Tags) => {
                    let json_tags = json!({
                        "tags": river_state.tags
                    });

                    let json_str = serde_json::to_string(&json_tags).unwrap();

                    println!("{}", json_str);
                }
                Some(RiverCommands::Layout) => {
                    let json_layout = json!({
                        "layout": river_state.layout
                    });
                    let json_str = serde_json::to_string(&json_layout).unwrap();
                    println!("{}", json_str);
                }
                Some(RiverCommands::Active) => {
                    let json_active = json!({
                        "active": river_state.active,
                        "active_empty": river_state.active_empty
                    });
                    let mut previous_json_str = serde_json::to_string(&json_active).unwrap();
                    println!("{}", previous_json_str);

                    if river.listen {
                        loop {
                            let _ = event_queue.roundtrip(&mut state);
                            sleep(Duration::from_millis(250));
                            if state.tags.clone().unwrap().contains(&active) {
                                active_empty = false;
                            }
                            let json_active = json!({
                                "active": state.focused_tags,
                                "active_empty": active_empty
                            });
                            let json_str = serde_json::to_string(&json_active).unwrap();

                            if json_str != previous_json_str {
                                println!("{}", json_str);
                                previous_json_str = json_str;
                            }
                        }
                    }
                }
                _ => {
                    let json = serde_json::to_string(&river_state).unwrap();
                    println!("{}", json);
                }
            }
        }
        Some(Commands::Wallpaper(wallpaper)) => match &wallpaper.command {
            Some(WallpaperCommands::Sort) => {
                let _ = proxy.sort().await;
            }

            _ => match &wallpaper.luminance {
                Some(Luminance::Dark) => {
                    let dark_wallpapers = proxy.get_dark().await?;
                    println!("{}", dark_wallpapers);
                }
                Some(Luminance::Light) => {
                    let light_wallpapers = proxy.get_light().await?;
                    println!("{}", light_wallpapers);
                }
                _ => {
                    let wallpapers = proxy.get().await?;
                    println!("{}", wallpapers);
                }
            },
        },

        _ => {
            unreachable!()
        }
    }

    Ok(ExitCode::SUCCESS)
}
