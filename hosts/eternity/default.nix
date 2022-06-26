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

      apps = {
        thunar.enable = true;
        flameshot.enable = true;
        discord.enable = true;
      };

      suckless = {
        dmenu.enable = true;
        dwm.enable = true;
        st.enable = true;
      };

      browsers = {
        default = "brave";
        firefox.enable = true;
        brave.enable = true;
      };

      term = {
        default = "st";
        # st.enable = true;
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
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
  };
  services = {
    xserver = {
      layout = "br";
      autoRepeatDelay = 200;
      autoRepeatInterval = 50;
    };
  };

  # Enable imwheel
  services.xserver.imwheel.enable = true;

  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking.networkmanager.enable = true;
}
