{
  config,
  lib,
  ...
}: {
  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    secrets = lib.my.getSecrets ./secrets/ssh.yaml {
      id_ed25519.path = ".ssh/id_ed25519";
      id_ed25519_pub.path = ".ssh/id_ed25519.pub";
    };
  };

  modules = {
    roots.enable = true;

    # theme = {
    #   oxocarbon.enable = true;
    # };

    shell = {
      zsh.enable = true;
    };

    desktop = {
      app = {
        file = {
          thunar.enable = true;
          dolphin.enable = true;
        };
        media = {
          vlc.enable = true;
          gwenview.enable = true;
          nomacs.enable = true;
          zathura.enable = true;
        };
        # connect.enable = true;
      };
      term = {
        kitty.enable = true;
      };
      browser = {
        firefox.enable = true;
        brave.enable = true;
      };
    };
    editor = {
      zed.enable = true;
      kakoune.enable = true;
    };
  };
}
