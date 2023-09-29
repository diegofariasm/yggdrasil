{ lib, inputs, ... }:
with lib;
with lib.my; {
  imports = [
    ../home.nix
    ./hardware-configuration.nix

    # The users for this host.
    (getUser "fushiii")

  ];

  # Automagically format the disk
  # and mount the partitions.
  disko.devices = import ./disko.nix { disks = [ "/dev/sda" ]; };

  ## Modules
  modules = {
    desktop = {
      hypr.enable = true;
      display = { gdm.enable = true; };
      apps = {
        wine.enable = true;
        gaming = {
          games = { roblox.enable = true; };
          steam.enable = true;
          heroic.enable = true;
        };
      };
    };

    hardware = {
      audio.enable = true;
      zram.enable = true;
      fs.enable = true;
    };

    services = {
      ssh.enable = true;
      docker.enable = true;
      tumbler.enable = true;
      udisks.enable = true;
      upower.enable = true;
    };
  };

}
