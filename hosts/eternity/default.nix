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
      fs.enable = true;
    };
    desktop = {
      dwm.enable = true;
      media = {
        vlc.enable = true;
        nomacs.enable = true;
        mpv.enable = true;
      };
      apps = {
        thunar.enable = true;
      };
      browsers = {
        default = "firefox";
        edge.enable = true;
        firefox.enable = true;
      };
      gaming = {
        emulators = {
          psx.enable = true;
        };
      };
      term = {
        default = "st";
        st.enable = true;
      };
    };
    dev = {
      shell.enable = true;
      go.enable = true;
      node.enable = true;
      rust.enable = true;
      python.enable = true;
    };
    editors = {
      default = "code";
      vim.enable = true;
      code.enable = true;
    };
    shell = {
      git.enable = true;
      elvish.enable = true;
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
  services.xserver = {
    layout = "br";
    autoRepeatDelay = 300;
    autoRepeatInterval = 20;
  };
  environment.variables = {
    "XKB_DEFAULT_LAYOUT" = "br";
  };
  # Enable imwheel
  services.xserver.imwheel.enable = true;
  # Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

}
