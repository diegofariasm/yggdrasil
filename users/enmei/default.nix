{ ... }:
let
  user = "enmei";
in
{
  users.users = {
    "${user}" = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
      ];
      hashedPassword = "$y$j9T$4kH1DpfluPRI4kjUG3eC..$O56uu5IvPNqoYDZ3zh95dNbiqHo7iQHcszhhVDdipo9";
    };
  };

  home-manager.users.${user} = { lib, config, ... }: {
    sops = {
      # Age key location.
      # Without having this on place,
      # you will not be able to get my secrets.
      age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";

      secrets = lib.getSecrets ./secrets/ssh.yaml {
        id_ed25519.path = ".ssh/id_ed25519";
        id_ed25519_pub.path = ".ssh/id_ed25519.pub";
      };
    };

    modules = {
      shell = {
        apps = {
          eza.enable = true;
          fzf.enable = true;
          zellij.enable = true;
          direnv.enable = true;
          starship.enable = true;
        };
      };

      desktop = {
        apps = {
          files = {
            default = {
              bin = "thunar";
            };
            thunar.enable = true;
          };
          discord.enable = true;
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
          firefox = {
            enable = true;
          };
          default.bin = "firefox";
        };

      };
      editors = {
        codium.enable = true;
        kakoune.enable = true;
      };
    };

  };
}
