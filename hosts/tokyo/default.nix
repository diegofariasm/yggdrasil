{ lib, inputs, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix

    (lib.getUser
      "nixos" "enmei"
    )
  ];

  disko.devices = import ./disko.nix { disks = [ "/dev/sda" ]; };

  modules = {
    shell.zsh.enable = true;
    boot = {
      loader = {
        systemd = {
          enable = true;
        };
        display.lightdm.enable = true;
      };
      splash.enable = true;
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

    desktop = {
      enable = true;
      hypr.enable = true;
      vm = {
        virtualbox = {
          enable = true;
        };
        qemu.enable = true;
      };
      services = {
        notifications = {
          mako.enable = true;
        };
        clipman.enable = true;
      };
    };
  };

}
