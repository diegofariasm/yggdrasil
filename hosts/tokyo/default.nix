{ lib, inputs, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix

    (lib.getUser "nixos" "enmei")
    (lib.getUser "nixos" "diegofariasm")
  ];

  disko.devices = import ./disko.nix { disks = [ "/dev/sda" ]; };

  modules = {
    shell.zsh.enable = true;


    desktop = {
      enable = true;
      hypr.enable = true;
      vm = {
        qemu.enable = true;
        virtualbox.enable = true;
      };
      services = {
        clipman.enable = true;
        notifications.mako.enable = true;
      };
    };

    hardware = {
      language = {
        en.enable = true;
        keyboard.br.enable = true;
      };
      bluetooth.enable = true;
      audio.enable = true;
    };

    boot = {
      loader = {
        systemd.enable = true;
        display.lightdm.enable = true;
      };
      splash.enable = true;
    };

    services = {
      docker.enable = true;
      ssh.enable = true;
    };

  };

}
