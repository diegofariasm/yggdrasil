{ config, pkgs, ... }:

let
  user = "fushiii";
in
{
  # Set up the user.
  # This needed for nixos, but soon i will
  # be making this separate from here, enabling other linux distros.
  users = {
    users = {
      "${user}" = {
        group = "users";
        shell = pkgs.zsh;
        isNormalUser = true;
        home = "/home/${user}";
        extraGroups = [
          "wheel"
          "docker"
        ];
        hashedPassword = "$y$j9T$4kH1DpfluPRI4kjUG3eC..$O56uu5IvPNqoYDZ3zh95dNbiqHo7iQHcszhhVDdipo9";
      };
    };

  };

  programs.zsh.enable = true;

  home-manager.users.${user} = { pkgs, config, ... }: {
    # Common user configuration.
    # Mostly home-manager stuff for now.
    imports = [
      ../default.nix
    ];

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
            default = {
              bin = "thunar";
            };
            thunar.enable = true;
          };
          media = {
            zathura.enable = true;
            nomacs.enable = true;
            vlc.enable = true;
          };
        };
        browsers = {
          default = {
            bin = "chromium";
          };
          chromium.enable = true;
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
          doom = {
            enable = true;
          };
        };
        default = {
          bin = "emacs";
        };
      };
      theme.active = "oxocarbon";
    };
  };
}
