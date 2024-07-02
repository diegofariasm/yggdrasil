{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    systems.url = "github:nix-systems/default";

    crane.url = "github:ipetkov/crane";
    rust-overlay.url = "github:oxalica/rust-overlay";

    advisory-db = {
      url = "github:rustsec/advisory-db";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    crane,
    advisory-db,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = with inputs; [
        flake-parts.flakeModules.easyOverlay
      ];
      systems = import inputs.systems;

      perSystem = {
        system,
        config,
        pkgs,
        ...
      }: let
        lib = pkgs.lib;

        toolchainPackages = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.rust-overlay.overlays.default
          ];
        };

        toolchain = toolchainPackages.rust-bin.stable.latest.default.override {
          extensions = [
            "rust-src"
            "rust-std"
            "rust-analyzer"
            "clippy"
            "cargo"
          ];
        };

        craneLib = (crane.mkLib pkgs).overrideToolchain toolchain;
        src = craneLib.cleanCargoSource ./.;

        commonArgs = {
          inherit src;
          strictDeps = true;

          nativeBuildInputs = with pkgs; [
            pkg-config
            protobuf
          ];

          buildInputs = with pkgs; [
            dbus
          ];
        };

        cargoArtifacts =
          craneLib.buildDepsOnly
          commonArgs;

        individualCrateArgs =
          commonArgs
          // {
            inherit cargoArtifacts;
            inherit (craneLib.crateNameFromCargoToml {inherit src;}) version;
            # NB: we disable tests since we'll run them all via cargo-nextest
            doCheck = false;
          };

        fileSetForCrate = crate:
          lib.fileset.toSource {
            root = ./.;
            fileset = lib.fileset.unions [
              ./Cargo.toml
              ./Cargo.lock
              ./yggdrasil-common
              crate
            ];
          };

        # Build the top-level crates of the workspace as individual derivations.
        # This allows consumers to only depend on (and build) only what they need.
        # Though it is possible to build the entire workspace as a single derivation,
        # so this is left up to you on how to organize things
        yggdrasil = craneLib.buildPackage (individualCrateArgs
          // {
            pname = "yggdrasil";
            cargoExtraArgs = "-p yggdrasil";
            src = fileSetForCrate ./yggdrasil;
          });

        yggdrasil-shell = craneLib.buildPackage (individualCrateArgs
          // {
            pname = "yggdrasil-shell";
            cargoExtraArgs = "-p yggdrasil-shell";
            src = fileSetForCrate ./yggdrasil-shell;
          });

        formatterDrv = pkgs.callPackage ./formatter.nix {};
      in {
        checks = {
          # Build the crates as part of `nix flake check` for convenience
          inherit yggdrasil yggdrasil-shell;

          # Run clippy (and deny all warnings) on the workspace source,
          # again, reusing the dependency artifacts from above.
          #
          # Note that this is done as a separate derivation so that
          # we can block the CI if there are issues here, but not
          # prevent downstream consumers from building our crate by itself.
          yggdrasil-workspace-clippy = craneLib.cargoClippy (commonArgs
            // {
              inherit cargoArtifacts;
              cargoClippyExtraArgs = "--all-targets -- --deny warnings";
            });

          yggdrasil-workspace-doc = craneLib.cargoDoc (commonArgs
            // {
              inherit cargoArtifacts;
            });

          # Check formatting
          yggdrasil-workspace-fmt = craneLib.cargoFmt {
            inherit src;
          };

          # Audit dependencies
          yggdrasil-workspace-audit = craneLib.cargoAudit {
            inherit src advisory-db;
          };

          # Audit licenses
          yggdrasil-workspace-deny = craneLib.cargoDeny {
            inherit src;
          };

          # Run tests with cargo-nextest
          # Consider setting `doCheck = false` on other crate derivations
          # if you do not want the tests to run twice
          yggdrasil-workspace-nextest = craneLib.cargoNextest (commonArgs
            // {
              inherit cargoArtifacts;
              partitions = 1;
              partitionType = "count";
            });
        };

        formatter = formatterDrv;

        packages = {
          inherit yggdrasil yggdrasil-shell;
        };
        overlayAttrs = {
          inherit (config.packages) yggdrasil yggdrasil-shell;
        };

        devShells = {
          default = pkgs.mkShell {
            inputsFrom = builtins.attrValues self.checks.${system};

            shellHook = ''
              export PATH="$PWD/target/debug/:$PATH"
            '';

            nativeBuildInputs = with pkgs; [
              pkg-config
              protobuf
            ];

            buildInputs = with pkgs; [
              toolchain
              dbus
              bacon
              deadnix
              zbus-xmlgen
              cargo-machete
              alejandra
            ];
          };
        };
      };
    };
}
