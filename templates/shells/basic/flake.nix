{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];
      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      perSystem = { config, self', inputs', pkgs, system, ... }:
        {
          _module.args = {
            pkgs = import inputs.nixpkgs {
              inherit system;
            };
          };

          devShells = {
            development = pkgs.mkShell {
              buildInputs = with pkgs; [
                hello
              ];
            };
          };

          devShells.default = devShells.development;

        };

    };
}

