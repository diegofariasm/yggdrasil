{
  inputs,
  defaultNixConf,
  lib,
  ...
}: {
  setups.nixos = {
    configs = {
      tokyo = {
        systems = ["x86_64-linux"];
        overlays = with inputs; [
          kak-rainbower.overlays.default
          flavours.overlays.default
          maiden.overlays.default
          zelda.overlays.default
        ];
        formats = null;
        modules = with inputs; [
          hyprland.nixosModules.default
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
        ];
        homeManagerUsers = {
          nixpkgsInstance = "global";
          users.diegofariasm = {
            userConfig = {
              extraGroups = [
                "wheel"
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
    };

    # Shared modules between the hosts.
    # Note that importing all my personal modules
    # here doesn't really matter, as they are all enable based.
    sharedModules =
      [
        defaultNixConf
        ({
          config,
          pkgs,
          lib,
          ...
        }: {
          environment = {
            systemPackages = with pkgs; [maiden zelda flavours];

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

          # It's following the 'nixpkgs' flake input which should be in unstable
          # branches. Not to mention, most of the system configurations should
          # have this attribute set explicitly by default.
          system.stateVersion = lib.mkDefault "24.05";
        })
        inputs.nix-index-database.nixosModules.nix-index
      ]
      ++ lib.my.modulesToList (lib.my.filesToAttr ../../modules/nixos);
  };

  flake = {
    nixosModules = lib.my.filesToAttr ../../modules/nixos;
  };
}
