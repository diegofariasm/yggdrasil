{ lib
, inputs
, ...
}:
with lib;
with lib.my;
{
  imports = [
    ../default.nix
    ./hardware-configuration.nix

    (getUser "enmei")
  ];


  disko.devices = import ./disko.nix { disks = [ "/dev/sda" ]; };

  modules = {
    shell.zsh.enable = true;
    boot = {
      loader = {
        systemd = {
          enable = true;
        };
        display.gdm.enable = true;
      };
      splash.enable = true;
    };

    desktop = {
      hyprland.enable = true;
      services = {
        notifier = {
          mako.enable = true;
        };
        clipman.enable = true;
      };

      gaming = {
        games = {
          roblox.enable = true;
        };
        steam.enable = true;
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
