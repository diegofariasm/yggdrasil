{
  description = "A basic development shell.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      perSystem = {
        pkgs,
        system,
        ...
      }: {
        _module.args = {
          pkgs = import inputs.nixpkgs {
            inherit system;
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            hello
          ];
        };
      };
    };
}
