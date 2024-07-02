{
  inputs,
  lib,
  defaultNixConf,
  ...
}: {
  setups.nixos = {
    configs = {
      asgard = {
        systems = ["x86_64-linux"];
        formats = null;
        modules = [
          inputs.disko.nixosModules.disko
          inputs.sops-nix.nixosModules.sops
        ];
        homeManagerUsers = {
          nixpkgsInstance = "global";
          users.baldur = {
            userConfig = {
              extraGroups = [
                "wheel"
                "vboxusers"
                "storage"
                "audio"
                "docker"
                "podman"
              ];
              hashedPassword = "$y$j9T$4kH1DpfluPRI4kjUG3eC..$O56uu5IvPNqoYDZ3zh95dNbiqHo7iQHcszhhVDdipo9";
            };
          };
        };
        nixpkgsBranch = "nixos-unstable";
      };

      bootstrap = {
        systems = ["x86_64-linux"];
        formats = ["install-iso"];
        nixpkgsBranch = "nixos-unstable-small";
      };

      graphical-installer = {
        systems = ["x86_64-linux"];
        formats = ["install-iso-graphical"];
      };
    };

    sharedOverlays = [
      inputs.yggdrasil-shell.overlays.default
    ];

    sharedModules = [
      defaultNixConf
      ({
        pkgs,
        lib,
        ...
      }: {
        environment = {
          systemPackages = with pkgs; [
            git
            cachix
            sops
            age
            cached-nix-shell
          ];

          sessionVariables = {
            XDG_CACHE_HOME = "$HOME/.cache";
            XDG_CONFIG_HOME = "$HOME/.config";
            XDG_DATA_HOME = "$HOME/.local/share";
            XDG_STATE_HOME = "$HOME/.local/state";
          };
        };

        # Find Nix files with these! Even if nix-index is already enabled, it
        # is better to make it explicit.
        programs = {
          command-not-found.enable = false;
          nix-index.enable = true;
        };

        environment.etc."yggdrasil".source = ../../.;

        # It's following the 'nixpkgs' flake input which should be in unstable
        # branches. Not to mention, most of the system configurations should
        # have this attribute set explicitly by default.
        system.stateVersion = lib.mkDefault "24.11";
      })
      inputs.nix-index-database.nixosModules.nix-index
    ];
  };

  flake = {
    nixosModules = lib.my.filesToAttr ../../modules/nixos;
  };
}
