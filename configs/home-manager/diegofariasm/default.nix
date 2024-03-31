{
  config,
  lib,
  ...
}: {
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
    dotfiles.enable = true;
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
        };
        kitty.enable = true;
      };
      browsers = {
        firefox.enable = true;
        brave.enable = true;
      };
    };
    editors = {
      code.enable = true;
      kakoune.enable = true;
    };
  };

  home.stateVersion = "23.11";
}
