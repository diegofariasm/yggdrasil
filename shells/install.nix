{pkgs}:
pkgs.mkShell {
  description = ''
    An development shell meant to be used for install.
  '';
  packages = with pkgs; [
    hello
  ];
}
