{...}: {
  imports = [
    ./hardware-configuration.nix
    ../default.nix
    ./disko.nix
  ];

  modules = {
    shell.zsh.enable = true;

    boot.loader = {
      systemd = {
        enable = true;
      };
    };
    desktop = {
      hypr.enable = true;

      #  apps = {
      #    emulation = {
      #      bottles.enable = true;
      #      vm = {
      #        lxd.enable = true;
      #        qemu.enable = true;
      #        virtualbox.enable = true;
      #      };
      #    };
      #  };

      services = {
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
      ssd.enable = true;
      audio.enable = true;
      intel.enable = true;
      wifi.enable = true;
      bluetooth.enable = true;
    };

    services = {
      ssh.enable = true;
      docker.enable = true;
    };
  };
}
