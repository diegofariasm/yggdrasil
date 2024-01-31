{pkgs}:
with pkgs; let
  nixBin = writeShellScriptBin "nix" ''
    ${nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';
in
  mkShell {
    description = ''
      An development shell meant to be used for installs.
    '';

    shellHook = ''
      export FLAKE="$(pwd)"
      export PATH="$FLAKE/bin:${nixBin}/bin:$PATH"
    '';

    packages = [
      git
      deploy-rs
      alejandra
    ];
  }
