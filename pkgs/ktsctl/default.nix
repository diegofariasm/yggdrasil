{
  gcc,
  lib,
  fetchzip,
  makeWrapper,
  rustPlatform,
  git,
}: let
  version = "ktsctl-v1.1.1";
in
  rustPlatform.buildRustPackage {
    pname = "ktsctl";
    inherit version;

    src = fetchzip {
      url = "https://git.sr.ht/~hadronized/kak-tree-sitter/archive/${version}.tar.gz";
      sha256 = "sha256-zlh4xtOfLSaLuXKmGy3lj5pyiaaL5S9QWODXyAJXHFw=";
    };

    nativeBuildInputs = [
      git
    ];

    buildInputs = [makeWrapper];

    postFixup = ''
      wrapProgram $out/bin/ktsctl \
        --prefix PATH : ${lib.makeBinPath [gcc]}
    '';

    cargoBuildFlags = "-p ktsctl";
    buildAndTestSubdir = "ktsctl";

    cargoSha256 = "sha256-GNubyv9L1cAL3CLSSmRPCgO/CCZKDJ1jIajAvUbV/V0=";
  }
