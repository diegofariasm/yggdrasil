{
  gcc,
  lib,
  fetchzip,
  makeWrapper,
  rustPlatform,
}: let
  version = "b390d1fb3e30582cf8b29d2648ef03355ae80283";
in
  rustPlatform.buildRustPackage {
    pname = "ktsctl";
    inherit version;

    src = fetchzip {
      url = "https://github.com/hadronized/kak-tree-sitter/archive/${version}.tar.gz";
      sha256 = "sha256-bCeA41DT8By3eIoGxyh6+BgwvszuJg7xKlm0y1Hsn0Q=";
    };

    # Patch to ensure the build phase does not rely on a .git folder
    patches = [
      ./build.patch
    ];

    cargoBuildFlags = "-p ktsctl";
    buildAndTestSubdir = "ktsctl";

    buildInputs = [makeWrapper];
    postFixup = ''
      wrapProgram $out/bin/ktsctl \
        --prefix PATH : ${lib.makeBinPath [gcc]}
    '';

    cargoSha256 = "sha256-KbkcHvMH+e0wDKgUGpbV3LwBLEZeKN1GAQ9/07eV3nM=";
  }
