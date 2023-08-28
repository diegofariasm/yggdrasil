{ config, pkgs, lib, ... }:

with lib;
with lib.my;
let
  user = "diegofariasm";
in
{
  users.users."${user}" = {
    group = "users";
    shell = pkgs.zsh;
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = [ "wheel" ];
    hashedPassword = "$6$YNJGW9lqQz5ccudx$NZnn/GlUXbeoyu6mD7/LLuqVMCd4v8pDmW0xEpMLXcv9gcFqZ24NDpkJxxgCCXbLkSCBiLJ9UdqUBKll4BvAO/";
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
        keyFile = "${config.xdg.configHome}/sops/age/diegofariasm";
      };
      defaultSopsFile = ./secrets/ssh.yaml;
      secrets = {
        diegofariasm.path = "${config.home.homeDirectory}/.ssh/diegofariasm";
        diegofariasm_pub.path = "${config.home.homeDirectory}/.ssh/diegofariasm.pub";
      };
    };

    modules = {
      shell = {
        zsh.enable = true;
        fzf.enable = true;
        direnv.enable = true;
        starship.enable = true;
      };
      desktop = {
        apps = {
          media = {
            vlc.enable = true;
            nomacs.enable = true;
          };
          thunar.enable = true;
          obsidian.enable = true;
        };
        browsers = {
          default = "firefox";
          firefox.enable = true;
        };
        term = {
          default = {
            name = "kitty";
            command = "kitty --single-instance";
          };
          kitty.enable = true;
        };
      };
      editors = {
        emacs = {
          enable = true;
          doom.enable = true;
        };
        nvim = {
          enable = true;
          nyoom.enable = true;
        };
        default = "nvim";
      };
      theme.active = "oxocarbon";
    };

  };
}
