{ config, lib, pkgs, ... }:

{
  imports = [
    ../../default.nix
  ];

  sops = {
    # Age key location.
    # Without having this on place,
    # you will not be able to get my secrets.
    age.keyFile = "${config.xdg.configHome}/age/user";
    secrets = lib.getSecrets ./secrets/ssh.yaml {
      id_ed25519.path = ".ssh/ id_ed25519";
      id_ed25519_pub.path = ".ssh/ id_ed25519.pub";
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
