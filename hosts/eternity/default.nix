{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    hardware = {
      intel.enable = true;
    };

    desktop = {
      sway.enable = true;
      plasma.enable = true; # This  needs  to be enabled so edge doesn't crash when save as is pressed

      media = {
        vlc.enable = true;
        mpv.enable = true;
        nomacs.enable = true;
      };
      apps = {
        thunar.enable = true;
        flameshot.enable = true;
        discord.enable = true;
        nautilus.enable = true;
        dolphin.enable = true;
      };

      suckless = {
        dmenu.enable = true;
        dwm.enable = true;
        st.enable = true;
      };

      browsers = {
        default = "firefox";
        edge.enable = true;
        firefox.enable = true;
      };

      term = {
        default = "st";
        #  st.enable = true;
      };
    };

    dev = {
      node.enable = true;
      rust.enable = true;
      python.enable = true;
    };

    editors = {
      default = "nvim";
      vim.enable = true;
      vs-code.enable = true;

    };

    shell = {
      adl.enable = true;
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      #tmux.enable = true;
      #zsh.enable = true;
      fish.enable = true;
    };

    services = {
      ssh.enable = true;
      mate-polkit.enable = true;
    };

    theme.active = "alucard";
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [terminus_font];
    keyMap = "br-abnt2";
  };

  services = {
    xserver = {
      layout = "br";
      autoRepeatDelay = 300;
      autoRepeatInterval = 20;
    };
  };

  # Enable imwheel
  services.xserver.imwheel.enable = true;

  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking.networkmanager.enable = true;
}
