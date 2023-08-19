{ ... }: {
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
