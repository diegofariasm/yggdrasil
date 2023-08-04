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
      hypr.enable = true;
      media = {
        vlc.enable = true;
        nomacs.enable = true;
      };
      apps = {
        editors = {
          code.enable = true;
        };
        thunar.enable = true;
      };
      browsers = {
        default = "firefox";
        firefox.enable = true;
        chromium.enable = true;
      };
      term = {
        default = {
          name = "kitty";
          command = "kitty --single-instance";
        };
        kitty.enable = true;
        st.enable = true;
      };
    };
    editors = {
      default = "nvim";
      vim.enable = true;
      emacs.enable = true;
    };
    shell = {
      zsh.enable = true;
      git.enable = true;
      tmux.enable = true;
      direnv.enable = true;
      starship.enable = true;
    };
    services = {
      polkit.enable = true;
      ssh.enable = true;
    };
    theme.active = "tokyo";
  };


  programs.ssh.startAgent = true;
  services.xserver.imwheel.enable = true;
  services.openssh.startWhenNeeded = true;
}
