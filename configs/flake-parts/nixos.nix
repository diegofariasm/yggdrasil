{
  inputs,
  defaultExtraArgs,
  defaultNixConf,
  lib,
  ...
}: {
  setups.nixos = {
    configs = {
      tokyo = {
        systems = [
          "x86_64-linux"
        ];
        overlays = [
          inputs.maiden.overlays.default
          inputs.flavours.overlays.default
          inputs.zelda.overlays.default
        ];
        formats = null;
        homeManagerUsers = {
          nixpkgsInstance = "global";
          users.enmeei = {
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

    sharedModules =
      [
        inputs.sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko

        # Bring our own teeny-tiny snippets of configurations.
        defaultNixConf

        # The NixOS module that came from flake-parts.
        ({
          config,
          lib,
          ...
        }: {
          _module.args = defaultExtraArgs;

          # Set several paths for the traditional channels.
          nix.nixPath =
            lib.mkIf config.nix.channel.enable
            (lib.mapAttrsToList
              (name: source: let
                name' =
                  if (name == "self")
                  then "config"
                  else name;
              in "${name'}=${source}")
              inputs
              ++ [
                "/nix/var/nix/profiles/per-user/root/channels"
              ]);

          programs.fuse.userAllowOther = true;

          system.stateVersion = lib.mkDefault "24.05";
        })
      ]
      ++ lib.my.modulesToList (lib.my.filesToAttr ../../modules/nixos);
  };

  flake = {
    nixosModules = lib.my.filesToAttr ../../modules/nixos;
  };
}
