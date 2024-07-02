{
  fetchzip,
  rustPlatform,
  git,
}: let
  version = "kak-tree-sitter-v1.1.1";
in
  rustPlatform.buildRustPackage {
    pname = "kak-tree-sitter";
    inherit version;

    src = fetchzip {
      url = "https://git.sr.ht/~hadronized/kak-tree-sitter/archive/${version}.tar.gz";
      sha256 = "sha256-XWxnnf+StlM63sjKZP5gLspfu800UP3Zkw9aA13GPmU=";
    };

    nativeBuildInputs = [
      git
    ];

    cargoBuildFlags = "-p kak-tree-sitter";
    buildAndTestSubdir = "kak-tree-sitter";

    cargoSha256 = "sha256-B8nXRakBlm584pR4Z9oI1GaSMK6gh+lHDk7GP7igbmo=";
  }
