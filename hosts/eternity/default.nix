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
        gdm.enable = true;
      };
    };

    hardware = {
      bluetooth.enable = true;
      audio.enable = true;
      fs.enable = true;
    };

    services = {
      ssh.enable = true;
      upower.enable = true;
    };
  };

}
