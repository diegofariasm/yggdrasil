{ ... }: {
  imports = [ ../home.nix ./hardware-configuration.nix ];
  # Automagically format the disk
  # and mount the partitions.
  disko.devices = import ./disko.nix { disks = [ "/dev/sda" ]; };

  ## Modules
  modules = {
    desktop = {
      hypr.enable = true;
      display = { gdm.enable = true; };
      apps = {
        gaming = {
          steam.enable = true;
          games = { roblox.enable = true; };
        };
      };
    };

    # These are generally by a lof of packages.
    # So, instead of i having to wrap to be able to install them,
    # i just install it globally and use it like that. I can just override it anyway.
    dev = {
      cc.enable = true;
      rust.enable = true;
    };

    hardware = {
      audio.enable = true;
      fs.enable = true;
    };

    services = {
      ssh.enable = true;
      upower.enable = true;
      docker.enable = true;
    };
  };

}
