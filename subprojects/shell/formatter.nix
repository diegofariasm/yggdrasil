{pkgs, ...}:
pkgs.writeShellApplication {
  name = "treefmt";

  runtimeInputs = with pkgs;
  with nodePackages; [
    treefmt
    alejandra
    rustfmt
  ];

  text = ''
    exec treefmt "$@"
  '';
}
