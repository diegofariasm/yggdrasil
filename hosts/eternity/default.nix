{ lib, inputs, ... }:

{
  imports = [
    ../home.nix
    ./hardware-configuration.nix

    # The users for this host.
    (lib.getUser "fushiii")

  ];

  # Automagically format the disk
  # and mount the partitions.
  disko.devices = import ./disko.nix { disks = [ "/dev/sda" ]; };

  # The host configuration.
  # This is available at modules/nixos.
  modules = {
    desktop = {
      hyprland.enable = true;
      display = {
        gdm.enable = true;
      };
      apps = {
        gaming = {
          games = {
            roblox.enable = true;
          };
          steam.enable = true;
        };
      };
    };

    hardware = {
      audio.enable = true;
      intel.enable = true;
      zram.enable = true;
      fs.enable = true;
    };
    services = {
      podman = {
        enable = true;
      };
      ssh.enable = true;
    };
  };

}
