# All of the development-related shtick for this project is over here.
{inputs, ...}: {
  imports = [
    inputs.pre-commit-hooks-nix.flakeModule
  ];

  perSystem = {pkgs, ...}: let
    formatter = pkgs.writeShellApplication {
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
    formatter = formatter;

    pre-commit = {
      check.enable = true;
      settings = {
        hooks = {
          deadnix.enable = true;
          treefmt = {
            enable = true;
            package = formatter;
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
        default = import ../../shells/install.nix {inherit pkgs;};
      };
  };
}
