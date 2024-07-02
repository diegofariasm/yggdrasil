{...}: {
  imports = [
    ./hardware-configuration.nix
    ../default.nix
    ./disko.nix
  ];

  modules = {
    shell = {
      zsh.enable = true;
    };
    boot.loader = {
      systemd = {
        enable = true;
      };
    };
    desktop = {
      river.enable = true;

      app = {
        gaming = {
          steam.enable = true;
        };
        emulation = {
          playstation = {
            one.enable = true;
            two.enable = true;
          };
          vm = {
            lxd.enable = true;
            qemu.enable = true;
            virtualbox.enable = true;
          };
          bottles.enable = true;
        };
        connect.enable = true;
      };

      service = {
        notifier = {
          mako.enable = true;
        };
        polkit.gnome.enable = true;
        kanshi.enable = true;
        gammastep.enable = true;
      };
    };

    hardware = {
      language = {
        keyboard = {
          br.enable = true;
        };
        en.enable = true;
      };
      controller.enable = true;
      ssd.enable = true;
      audio.enable = true;
      intel.enable = true;
      wifi.enable = true;
      bluetooth.enable = true;
    };

    service = {
      ssh.enable = true;
      docker.enable = true;
    };
  };
}
