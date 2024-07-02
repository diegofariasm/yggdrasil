# All of the development-related shtick for this project is over here.
{inputs, ...}: {
  imports = [
    inputs.pre-commit-hooks-nix.flakeModule
  ];

  perSystem = {
    config,
    pkgs,
    ...
  }: let
    formatterPackage = pkgs.writeShellApplication {
      name = "treefmt";
      runtimeInputs = with pkgs; [
        treefmt
        alejandra
      ];
      text = ''
        exec treefmt "$@"
      '';
    };
  in {
    # No amount of formatters will make this codebase nicer but it sure does
    # feel like it does.
    formatter = formatterPackage;

    pre-commit = {
      settings = {
        hooks = {
          deadnix.enable = true;
          treefmt = {
            enable = true;
            package = formatterPackage;
          };
        };
      };
    };

    # My several development shells for usual type of projects. This is much
    # more preferable than installing all of the packages at the system
    # configuration (or even home environment).
    devShells =
      import ../../shells {inherit pkgs;}
      // {
        default = pkgs.mkShell {
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';

          packages = with pkgs; [
            formatterPackage
          ];
        };
      };
  };
}
