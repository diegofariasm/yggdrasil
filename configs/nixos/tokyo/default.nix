{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostId = "16c6bb2e";

  modules = {
    shell.zsh.enable = true;
    boot = {
      loader = {
        systemd = {
          enable = true;
        };
        display.gdm.enable = true;
      };
    };
    desktop = {
      hyprland.enable = true;
      services = {
        notifier = {
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
