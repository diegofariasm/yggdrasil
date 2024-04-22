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
        # overlays = [
        #   inputs.kak-rainbower.overlays.default
        #   inputs.flavours.overlays.default
        #   inputs.maiden.overlays.default
        #   inputs.zelda.overlays.default
        # ];
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
      };

      bootstrap = {
        systems = ["x86_64-linux"];
        formats = ["install-iso"];
        nixpkgsBranch = "nixos-unstable-small";
      };

      graphical-installer = {
        systems = ["x86_64-linux"];
        formats = ["install-iso-graphical"];
        nixpkgsBranch = "nixos-unstable";
      };
    };

    sharedModules = [
      defaultNixConf
      ({
        pkgs,
        lib,
        ...
      }: let
        importSystemEnvironment = pkgs.writeScriptBin "importSystemEnvironment" ''
          #!${pkgs.stdenv.shell}

          echo "System environment"
          ${pkgs.systemd}/bin/systemctl show-environment

          echo "Importing system environment"
          ${pkgs.systemd}/bin/systemctl import-environment

          echo "Imported system environment"
          ${pkgs.systemd}/bin/systemctl show-environment
        '';
      in {
        # environment.systemPackages = [importSystemEnvironment];
        # Like is explicit by the name, we import the user environment to systemctl.
        # In my opnion, this is the sane thing to do. Running user services with the user environment.
        # system.userActivationScripts.importSystemEnvironment = ''
        #   ${importSystemEnvironment}/bin/importSystemEnvironment
        # '';

        environment = {
          systemPackages = with pkgs; [
            git
            nil
            nixpkgs-fmt
            alejandra
            duf
            file
            killall
            tree
            tldr
            shellcheck
            shfmt
            fd
            sops
            age
            unzip
            zip
            rm-improved
            importSystemEnvironment
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
        system.stateVersion = lib.mkDefault "24.05";
      })
      inputs.nix-index-database.nixosModules.nix-index
    ];

    sharedOverlays = [
      inputs.kak-rainbower.overlays.default
    ];
  };

  flake = {
    nixosModules = lib.my.filesToAttr ../../modules/nixos;
  };
}
