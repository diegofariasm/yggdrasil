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
    # // (lib.my.getSecrets ./secrets/github.yaml
    #   (lib.my.attachSopsPathPrefix "github" {
    #     token_nix = {};
    #   }));
  };

  # Authenticated git calls.
  # Just makes you less likely to be rate-limited.
  # nix.extraOptions = ''
  #   !include ${config.sops.secrets."github/token_nix".path}
  # '';

  modules = {
    roots.enable = true;

    shell = {
      apps = {
        starship.enable = true;
        eza.enable = true;
        fzf.enable = true;
        zellij.enable = true;
        direnv.enable = true;
      };
      zsh.enable = true;
    };

    desktop = {
      apps = {
        files = {
          thunar.enable = true;
          dolphin.enable = true;
        };
        media = {
          vlc.enable = true;
          nomacs.enable = true;
          zathura.enable = true;
        };
      };
      term = {
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

  home.stateVersion = "24.05";
}
