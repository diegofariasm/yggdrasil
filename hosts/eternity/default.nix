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
      intel.enable = true;
      audio.enable = true;
      fs.enable = true;
    };

    desktop = {
      dwm.enable = true;
      media = {
        vlc.enable = true;
        nomacs.enable = true;
      };

      apps = {
        dmenu.enable = true;
        thunar.enable = true;
        neofetch.enable = true;
        qbit.enable = true;
      };

      browsers = {
        default = "firefox";
        edge.enable = true;
        firefox.enable = true;
      };

      term = {
        default = "kitty";
        st.enable = true;
        kitty.enable = true;
      };

    };

    dev = {
      cc.enable = true;
      node.enable = true;
      rust.enable = true;
      python.enable = true;
      go.enable = true;
    };

    editors = {
      default = "nvim";
      vim.enable = true;
      code.enable = true;
    };

    shell = {
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      fish.enable = true;
    };

    services = {
      ssh.enable = true;
      mate-polkit.enable = true;
      teamviewer.enable = true;
    };

    theme.active = "alucard";
  };

  # TTY config
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-116n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "br-abnt2";
  };

  services = {
    xserver = {
      layout = "br";
      autoRepeatDelay = 300;
      autoRepeatInterval = 20;
    };
  };

  environment.variables = {
    "XKB_DEFAULT_LAYOUT" = "br";
  };

  # Enable imwheel
  services.xserver.imwheel.enable = true;

  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking.networkmanager.enable = true;




}
