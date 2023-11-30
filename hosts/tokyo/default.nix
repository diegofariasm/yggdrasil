{ lib, inputs, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix

    (lib.getUser "enmei")
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


    desktop = {
      hypr.enable = true;
      services = {
        notifications = {
          mako.enable = true;
        };
        clipman.enable = true;
      };
    };


    hardware = {
      language = {
        keyboard = {
          br.enable = true;
        };
        en.enable = true;
      };
      audio.enable = true;
    };

    services = {
      docker.enable = true;
      ssh.enable = true;
    };
  };

}
