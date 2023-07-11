{ pkgs
, config
, lib
, ...
}: {
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];
  ## Modules
  modules = {
    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      fs.enable = true;
    };
    desktop = {
      dwm.enable = true;
      media = {
        vlc.enable = true;
        nomacs.enable = true;
        editing.enable = true;
      };
      apps = {
        editors = {
          code.enable = true;
        };
        # teamviewer.enable = true;
        thunar.enable = true;
      };
      browsers = {
        default = "google-chrome";
	chrome.enable = true;
	firefox.enable = true;
      };
      term = {
        default = "st";
        st.enable = true;
      };
    };
    dev = {
      shell.enable = true;
      cc.enable = true;
      rust.enable = true;
      dotnet.enable = true;
      node.enable = true;
      python.enable = true;
    };
    editors = {
      default = "nvim";
      vim.enable = true;
    };
    shell = {
      zsh.enable = true;
      git.enable = true;
      tmux.enable = true;
      starship.enable = true;
    };
    services = {
      polkit.enable = true;
      ssh.enable = true;
    };
    theme.active = "nordic";
  };

  # Tty config
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-116n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "br-abnt2";
  };

  environment.variables."XKB_DEFAULT_LAYOUT" = "br";

  networking.networkmanager.enable = true;
  # Local config
  programs.ssh.startAgent = true;
  services = {
    openssh.startWhenNeeded = true;
    xserver = {
      # Mouse configuration
      imwheel.enable = true;
      # Keyboard configuration
      layout = "br";
      autoRepeatDelay = 300;
      autoRepeatInterval = 20;
      # Touchpad configuration
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = true;
          middleEmulation = true;
          tapping = true;
        };
      };
    };
  };

}
