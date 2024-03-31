# All of the development-related shtick for this project is over here.
{lib, ...}: {
  flake.lib = lib;

  perSystem = {pkgs, ...}: {
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
