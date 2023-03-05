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
      intel.enable = true;
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
        element.enable = true;
        thunar.enable = true;
      };
      browsers = {
        default = "firefox";
        firefox.enable = true;
        chrome.enable = true;
        edge.enable = true;
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
      node.enable = true;
      python.enable = true;
    };
    editors = {
      default = "code";
      vim.enable = true;
      code.enable = true;
    };
    shell = {
      zsh.enable = true;
      git.enable = true;
      tmux.enable = true;
      pass.enable = true;
      gnupg.enable = true;
      direnv.enable = true;
      starship.enable = true;
      vaultwarden.enable = true;
    };
    services = {
      mate-polkit.enable = true;
      ssh.enable = true;
    };
    theme.active = "alucard";
  };

  # Tty config
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-116n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "br-abnt2";
  };

  environment.variables = {
    "XKB_DEFAULT_LAYOUT" = "br";
  };

  networking = {
    networkmanager.enable = true;
    # wireless = {
    #   enable = true;
    #   userControlled.enable = true;
    # };
  };

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
