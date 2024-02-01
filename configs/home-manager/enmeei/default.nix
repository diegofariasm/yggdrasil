{
  config,
  lib,
  pkgs,
  ...
}: let
  user = "enmeei";
in {
  sops = {
    # Age key location.
    # Without having this on place,
    # you will not be able to get my secrets.
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";

    secrets = lib.my.getSecrets ./secrets/ssh.yaml {
      id_ed25519.path = ".ssh/id_ed25519";
      id_ed25519_pub.path = ".ssh/id_ed25519.pub";
    };
  };

  modules = {
    shell = {
      apps = {
        starship.enable = true;
        eza.enable = true;
        fzf.enable = true;
        zellij.enable = true;
        direnv.enable = true;
      };
    };

    desktop = {
      apps = {
        files = {
          thunar.enable = true;
        };
        media = {
          vlc.enable = true;
          nomacs.enable = true;
          zathura.enable = true;
        };
        logseq.enable = true;
      };
      term = {
        default = {
          bin = "kitty";
          args = [
            "--single-instance"
          ];
        };
        kitty.enable = true;
      };
      browsers = {
        brave.enable = true;
      };
    };
    editors = {
      code.enable = true;
      kakoune.enable = true;
    };
  };

  home.persistence."/persist/home/${user}" = {
    allowOther = true;
    directories =
      [
        {
          directory = ".config/hypr";
          method = "symlink";
        }
        {
          directory = ".config/eww";
          method = "symlink";
        }
        {
          directory = ".local/share/flavours";
          method = "symlink";
        }

        {
          directory = ".config/flavours";
          method = "symlink";
        }
        {
          directory = ".config/zsh";
          method = "symlink";
        }
        {
          directory = ".config/xsettingsd";
          method = "symlink";
        }
        {
          directory = ".config/mako";
          method = "symlink";
        }
        {
          directory = ".config/gtk-2.0";
          method = "symlink";
        }
        {
          directory = ".config/gtk-3.0";
          method = "symlink";
        }
        {
          directory = ".config/gtk-4.0";
          method = "symlink";
        }

        {
          directory = ".config/sops";
          method = "symlink";
        }
        {
          directory = ".themes";
          method = "symlink";
        }
        "projects"
      ]
      ++ config.home.persist.directories
      ++ builtins.map (str: lib.removePrefix "/home/${user}/" str) (lib.attrValues (lib.filterAttrs (key: value: key != "enable" && key != "createDirectories" && key != "extraConfig" && key != "publishShare") config.xdg.userDirs));

    files =
      [
        ".zshrc"
        ".xsettingsd"
        ".config/starship.toml"
        ".config/maiden/config.toml"
      ]
      ++ config.home.persist.files;
  };

  home.stateVersion = "23.11";
}
