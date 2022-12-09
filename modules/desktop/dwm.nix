{ pkgs
, config
, lib
, options
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.dwm;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.dwm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        dwm = prev.dwm.overrideAttrs (old: {
          preBuild = ''
            NIX_CFLAGS_COMPILE+="-O3 -march=native"
          '';
          src = builtins.fetchTarball {
            url = "https://github.com/fushiii/dwm/archive/0b12b850d4cd1923ab7b92fccc8e89eb14d7d4ff.tar.gz";
            sha256 = "0cn2n96ips1i7fpc72yhhpqg1w3a8js747zkmx69c46jyygw6fix";
          };
          nativeBuildInputs = with pkgs; [ xorg.libX11 imlib2 ];
        });
      })
    ];

    services = {
      xserver = {
        enable = true;
        displayManager = {
          defaultSession = "none+dwm";
          lightdm.enable = true;
        };
        windowManager.dwm.enable = true;
      };


      picom = {
        enable = true;
        backend = "glx";
        vSync = true;

        shadow = true;
        shadowOffsets = [
          (-7)
          (-7)
        ];

        shadowOpacity = 0.75;
        shadowExclude = [
          "name = 'Notification'"
          "name = 'Plank'"
          "name = 'Docky'"
          "name = 'Kupfer'"
          "name = 'xfce4-notifyd'"
          "name *= 'VLC'"
          "name *= 'compton'"
          "name *= 'picom'"
          "name *= 'Chromium'"
          "name *= 'Chrome'"
          "class_g = 'Firefox' && argb"
          "class_g = 'Conky'"
          "class_g = 'Kupfer'"
          "class_g = 'Synapse'"
          "class_g ?= 'Notify-osd'"
          "class_g ?= 'Cairo-dock'"
          "class_g = 'Cairo-clock'"
          "class_g ?= 'Xfce4-notifyd'"
          "class_g ?= 'Xfce4-power-manager'"
          "_GTK_FRAME_EXTENTS@:c"
          "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
          "name *= 'maim'"
          "name *= 'GLava'"
        ];

        inactiveOpacity = 1;
        activeOpacity = 1;

        fade = true;
        fadeSteps = [
          0.03
          0.03
        ];
        menuOpacity = 0.9;

        wintypes = {
          tooltip = { fade = true; shadow = true; opacity = 0.9; focus = true; };
          dock = { shadow = false; };
          dnd = { shadow = false; };
          popup_menu = { opacity = config.services.picom.menuOpacity; };
          dropdown_menu = { opacity = config.services.picom.menuOpacity; };
        };

        settings = {
          fade-delta = 4;
          frame-opacity = 0.8;
          inactive-opacity-override = false;

          # Dim inactive windows. (0.0 - 1.0)
          inactive-dim = 0.2;
          # Do not let dimness adjust based on window opacity.
          inactive-dim-fixed = true;
          # Blur background of transparent windows. Bad performance with X Render backend. GLX backend is preferred.
          blur-background = true;
          # Blur background of opaque windows with transparent frames as well.
          blur-background-frame = true;
          # Do not let blur radius adjust based on window opacity.
          blur-background-fixed = true;
          blur-background-exclude = [
            "window_type = 'dock'"
            "window_type = 'desktop'"
            "_GTK_FRAME_EXTENTS@:c"
            "name = 'maim'"
            "name *= 'GLava'"
          ];

          blur-kern = "3x3box";
          blur-method = "dual_kawase";
          blur-strength = 4;



          glx-no-stencil = true;

          # GLX backend: Copy unmodified regions from front buffer instead of redrawing them all.
          # My tests with nvidia-drivers show a 10% decrease in performance when the whole screen is modified,
          # but a 20% increase when only 1/4 is.
          # My tests on nouveau show terrible slowdown.
          glx-copy-from-front = false;

          # GLX backend: Use MESA_copy_sub_buffer to do partial screen update.
          # My tests on nouveau shows a 200% performance boost when only 1/4 of the screen is updated.
          # May break VSync and is not available on some drivers.
          # Overrides --glx-copy-from-front.
          # glx-use-copysubbuffermesa = true;

          # GLX backend: Avoid rebinding pixmap on window damage.
          # Probably could improve performance on rapid window content changes, but is known to break things on some drivers (LLVMpipe).
          # Recommended if it works.
          # glx-no-rebind-pixmap = true;

          # GLX backend: GLX buffer swap method we assume.
          # Could be undefined (0), copy (1), exchange (2), 3-6, or buffer-age (-1).
          # undefined is the slowest and the safest, and the default value.
          # copy is fastest, but may fail on some drivers,
          # 2-6 are gradually slower but safer (6 is still faster than 0).
          # Usually, double buffer means 2, triple buffer means 3.
          # buffer-age means auto-detect using GLX_EXT_buffer_age, supported by some drivers.
          # Useless with --glx-use-copysubbuffermesa.
          # Partially breaks --resize-damage.
          # Defaults to undefined.
          #glx-swap-method = "undefined";

          animations = true;
          # `auto`, `none`, `fly-in`, `zoom`, `slide-down`, `slide-up`, `slide-left`, `slide-right` `slide-in`, `slide-out`
          animation-for-transient-window = "zoom";
          animation-for-open-window = "zoom";
          animation-for-close-window = "zoom";
          animation-for-unmap-window = "fly-in";
          animation-dampening = 20;
          animation-window-mass = 0.5;
          animation-clamping = false;

          # Try to detect WM windows and mark them as active.
          mark-wmwin-focused = true;
          # Mark all non-WM but override-redirect windows active (e.g. menus).
          mark-ovredir-focused = true;
          # Use EWMH _NET_WM_ACTIVE_WINDOW to determine which window is focused instead of using FocusIn/Out events.
          # Usually more reliable but depends on a EWMH-compliant WM.
          use-ewmh-active-win = true;
          # Detect rounded corners and treat them as rectangular when --shadow-ignore-shaped is on.
          detect-rounded-corners = true;

          # Detect _NET_WM_OPACITY on client windows, useful for window managers not passing _NET_WM_OPACITY of client windows to frame windows.
          # This prevents opacity being ignored for some apps.
          # For example without this enabled my xfce4-notifyd is 100% opacity no matter what.
          detect-client-opacity = true;

          corner-radius = 6;
          round-borders = 1;


          # Enable DBE painting mode, intended to use with VSync to (hopefully) eliminate tearing.
          # Reported to have no effect, though.
          dbe = false;

          # Limit picom to repaint at most once every 1 / refresh_rate second to boost performance.
          # This should not be used with --vsync drm/opengl/opengl-oml as they essentially does --sw-opti's job already,
          # unless you wish to specify a lower refresh rate than the actual value.
          #sw-opti = true;

          # Unredirect all windows if a full-screen opaque window is detected, to maximize performance for full-screen windows, like games.
          # Known to cause flickering when redirecting/unredirecting windows.
          unredir-if-possible = false;


          # Use WM_TRANSIENT_FOR to group windows, and consider windows in the same group focused at the same time.
          detect-transient = true;
          # Use WM_CLIENT_LEADER to group windows, and consider windows in the same group focused at the same time.
          # WM_TRANSIENT_FOR has higher priority if --detect-transient is enabled, too.
          detect-client-leader = true;


          ######################
          #
          # XSync
          # See: https://github.com/yshui/compton/commit/b18d46bcbdc35a3b5620d817dd46fbc76485c20d
          #
          ######################

          # Use X Sync fence to sync clients' draw calls. Needed on nvidia-drivers with GLX backend for some users.
          xrender-sync-fence = true;

        };
      };
    };

    home.packages = with pkgs; [
      my.luastatus # Status bar generator
      feh # Wallpaper setter
      procps # dmenu uptime
      picom
      pamixer
    ];

    fonts.fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "DroidSansMono"
          "Iosevka"
          "SourceCodePro"
          "Hack"
          "Meslo"
        ];
      })
    ];

    home.configFile."dwm" = {
      source = "${configDir}/dwm";
      recursive = true;
    };

  };
}
