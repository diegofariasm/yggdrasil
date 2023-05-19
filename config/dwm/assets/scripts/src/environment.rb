module Environment
  HOME_DIR = ENV["HOME"]
  CACHE_DIR = ENV["XDG_CACHE_HOME"] || "#{HOME_DIR}/.cache"
  CONFIG_DIR = ENV["XDG_CONFIG_HOME"] || "#{$HOME_DIR}/.config"
  RUNTIME_DIR = ENV["XDG_RUNTIME_DIR"] || '/run/user/#{Process.uid}'

  DWM_DIR = "#{CONFIG_DIR}/dwm"
  ROFI_DIR = "#{DWM_DIR}/config/rofi"
  LUASTATUS_DIR = "#{DWM_DIR}/config/luastatus"
  WALLPAPER_DIR = "#{DWM_DIR}/assets/wallpaper"
  XRESOURCES_FILE = "#{DWM_DIR}/xresources"

  THEME_ICON = "󱠓"
  THEME_DIR = "#{DWM_DIR}/themes"
end
