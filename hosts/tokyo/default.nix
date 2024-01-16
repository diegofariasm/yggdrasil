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
    ./disko.nix
    (getUser "enmei")
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
      splash.enable = true;
    };

    desktop = {
      hyprland.enable = true;
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
