{ lib, inputs, ... }:

{
  imports = [
    ../home.nix
    ./hardware-configuration.nix

    (lib.getUser "diegofariasm")
  ];

  # Automagically format the disk
  # and mount the partitions.
  disko.devices = import ./disko.nix { disks = [ "/dev/nvme0n1" ]; };

  # The host configuration.
  # This is available at modules/nixos.
  modules = {
    boot = {
      loader = {
        systemd = {
          enable = true;
        };
        display.lightdm.enable = true;
      };
      splash.enable = true;
    };



    desktop = {
      enable = true;
      hypr.enable = true;
      vm = {
        virtualbox.enable = true;
        qemu.enable = true;
      };
      services = {
        notifications.mako.enable = true;
        clipman.enable = true;
      };
    };


    # Hardware related things.
    # Language settings are here, but that is
    # just because the keyboard modules are also here.
    hardware = {
      language = {
        keyboard = {
          br.enable = true;
        };
        en.enable = true;
      };
      bluetooth.enable = true;
      audio.enable = true;
    };



    services = {
      docker.enable = true;
      ssh.enable = true;
    };
  };
  networking.networkmanager.enable = true;
};

}
