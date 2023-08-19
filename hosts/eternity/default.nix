{ ... }: {
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];
  # Automagically format the disk
  # and mount the partitions.
  disko.devices = import ./disko.nix {
    disks = [
      "/dev/sda"
    ];
  };

  ## Modules
  modules = {
    desktop = {
      hypr.enable = true;
      display = {
        lightdm.enable = true;
      };
    };

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
