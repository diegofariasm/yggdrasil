{
  fetchzip,
  rustPlatform,
}: let
  version = "b390d1fb3e30582cf8b29d2648ef03355ae80283";
in
  rustPlatform.buildRustPackage {
    pname = "kak-tree-sitter";
    inherit version;

    src = fetchzip {
      url = "https://github.com/hadronized/kak-tree-sitter/archive/${version}.tar.gz";
      sha256 = "sha256-bCeA41DT8By3eIoGxyh6+BgwvszuJg7xKlm0y1Hsn0Q=";
    };

    cargoBuildFlags = "-p kak-tree-sitter";
    buildAndTestSubdir = "kak-tree-sitter";

    # Patch to ensure the build phase does not rely on a .git folder
    patches = [
      ./build.patch
    ];

    cargoSha256 = "sha256-nLm5qYCmEWKcyvTRZFgwFzAS9qu09bTdneuDklfyjH8=";
  }
