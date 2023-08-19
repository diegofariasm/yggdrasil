{ pkgs
, config
, lib
, ...
}: {
  imports = [
    ../home.nix
    ./hardware-configuration.nix

    # The users for this host
    (lib.my.getUser "fushi")
  ];


  ## Modules
  modules = {
    hardware = {
      audio.enable = true;
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
      term = {
        default = {
          name = "kitty";
          command = "kitty --single-instance";
        };
        kitty.enable = true;
      };
    };
    shell = {
      zsh.enable = true;
      git.enable = true;
      direnv.enable = true;
    };
    services = {
      polkit.enable = true;
      ssh.enable = true;
    };
  };


  programs.ssh.startAgent = true;
  services.xserver.imwheel.enable = true;
  services.openssh.startWhenNeeded = true;
}
