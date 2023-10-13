{ config, pkgs, ... }:

let user = "fushiii";
in {

  sops = {
    age = {
      # Age key location.
      # Might change it to the /etc/nixos folder.
      # Does it get copied to the nix store?
      keyFile = "/etc/nixos/age/master";
    };
    defaultSopsFile = ./secrets/user.yaml;
    secrets = { password = { }; };
  };

  users.users."${user}" = {
    group = "users";
    shell = pkgs.zsh;
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = [ "wheel" "docker" ];
    hashedPasswordFile = config.sops.secrets.password.path;
  };

  programs.zsh.enable = true;

  home-manager.users.${user} = { pkgs, config, ... }: {
    # Secrets related to this account.
    # Don't go snooping around
    sops = {
      age = {
        # Age key location.
        # Might change it to the /etc/nixos folder.
        # Does it get copied to the nix store?
        keyFile = "/etc/nixos/age/master";
      };
      defaultSopsFile = ./secrets/ssh.yaml;
      secrets = {
        fushiii.path = ".ssh/fushiii";
        fushiii_pub.path = ".ssh/fushiii.pub";
        diegofariasm.path = ".ssh/diegofariasm";
        diegofariasm_pub.path = ".ssh/diegofarias.pub";
      };
    };


    modules = {
      shell = {
        zsh.enable = true;
        eza.enable = true;
        fzf.enable = true;
        tmux.enable = true;
        direnv.enable = true;
        starship.enable = true;
      };
      desktop = {
        services = {
          notifications = {
            mako.enable = true;
          };
          clipman.enable = true;
        };
        apps = {
          files = {
            thunar.enable = true;
            default = {
              bin = "thunar";
            };
          };
          media = {
            zathura.enable = true;
            nomacs.enable = true;
            vlc.enable = true;
          };
          discord.enable = true;
        };
        browsers = {
          default = {
            bin = "firefox";
          };
          firefox.enable = true;
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
      };
      editors = {
        kakoune.enable = true;
        emacs = {
          enable = true;
          doom.enable = true;
        };
        default = { bin = "emacs"; };
      };
    };
  };
}
