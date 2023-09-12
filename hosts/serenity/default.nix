{ lib, inputs, ... }:
with lib;
with lib.my;
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix

    # The users for this host.
    (getUser "diegofariasm")
  ];
  # Automagically format the disk
  # and mount the partitions.
  disko.devices = import ./disko.nix { disks = [ "/dev/nvme0n1" ]; };

  ## Modules
  modules = {
    desktop = {
      hypr.enable = true;
      display = {
        gdm.enable = true;
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
      zram.enable = true;
      fs.enable = true;
    };

    services = {
      ssh.enable = true;
      docker.enable = true;
      udiskie.enable = true;
    };
  };

}
