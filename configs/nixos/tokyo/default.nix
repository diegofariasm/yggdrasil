{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../default.nix
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
      river.enable = true;
      apps = {
        kde = {
          connect.enable = true;
        };
      };
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
      ssd.enable = true;
      audio.enable = true;
      intel.enable = true;
    };

    services = {
      ssh.enable = true;
      docker.enable = true;
    };
  };
}
