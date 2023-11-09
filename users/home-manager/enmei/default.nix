{ config, lib, pkgs, ... }:

{
  imports = [
    ../../default.nix
  ];

  # Secrets related to this account.
  # Don't go snooping around
  sops = {
    age = {
      # Age key location.
      # Might change it to the /etc/nixos folder.
      # Does it get copied to the nix store?
      keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    };
    defaultSopsFile = ./secrets/ssh.yaml;
    secrets = {
      id_rsa.path = ".ssh/id_rsa";
      id_rsa_pub.path = ".ssh/id_rsa.pub";
    };
  };

  modules = {
    shell = {
      apps = {
        eza.enable = true;
        fzf.enable = true;
        tmux.enable = true;
        direnv.enable = true;
      };
      prompt.starship.enable = true;
    };

    desktop = {
      apps = {
        files = {
          default = {
            bin = "thunar";
          };
          thunar.enable = true;
        };
      };
      term = {
        default = {
          bin = "kitty";
        };
        kitty.enable = true;
      };
      browsers = {
        default = {
          bin = "firefox";
        };
        firefox.enable = true;
      };

    };
    editors = {
      kakoune.enable = true;
    };
    theme.active = "gruvbox";
  };

}
