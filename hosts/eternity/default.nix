{ ... }: {
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];


  ## Modules
  modules = {
    desktop.hypr.enable = true;

    hardware = {
      audio.enable = true;
      fs.enable = true;
    };

    services = {
      docker.enable = true;
      ssh.enable = true;
    };
  };

}
