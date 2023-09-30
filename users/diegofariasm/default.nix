{ config, pkgs, ... }:

let user = "diegofariasm";
in
{

  sops = {
    age = {
      # Age key location.
      # Might change it to the /etc/dotfiles folder.
      # Does it get copied to the nix store?
      keyFile = "/etc/dotfiles/age/master";
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
        # Might change it to the /etc/dotfiles folder.
        # Does it get copied to the nix store?
        keyFile = "/etc/dotfiles/age/master";
      };
      defaultSopsFile = ./secrets/ssh.yaml;
      secrets = {
        id_rsa.path = ".ssh/diegofariasm";
        id_rsa_pub.path = ".ssh/diegofariasm.pub";
      };
    };

    modules = {
      shell = {
        zsh.enable = true;
        eza.enable = true;
        fzf.enable = true;
        direnv.enable = true;
        starship.enable = true;
      };
      desktop = {
        services = {
          notifications = { mako.enable = true; };
          udiskie.enable = true;
          clipman.enable = true;
        };
        apps = {
          media = {
            vlc.enable = true;
            nomacs.enable = true;
          };
          thunar.enable = true;
        };
        browsers = {
          default = "firefox";
          firefox.enable = true;
        };
        term = {
          default = { bin = "wezterm"; };
          wezterm.enable = true;
        };
      };
      editors = {
        emacs = {
          enable = true;
          doom.enable = true;
        };
        default = { bin = "emacs"; };
      };
      theme.active = "oxocarbon";
    };
  };
}
