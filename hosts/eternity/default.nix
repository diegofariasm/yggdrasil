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


  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;
}
