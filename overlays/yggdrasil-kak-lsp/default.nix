_final: prev: {
  yggdrasil-kak-lsp = prev.kak-lsp.overrideAttrs (old: rec {
    pname = "yggdrasil-kak-lsp";
    version = "master";

    src = prev.fetchFromGitHub {
      owner = "kakoune-lsp";
      repo = "kakoune-lsp";
      rev = "377a1a053f0ec74b88752756076adc1985a73023";
      sha256 = "sha256-zFmVA6/XICahChz1dtwwue1XCT5Qx2sYnoiAres2Y64=";
    };

    cargoDeps = old.cargoDeps.overrideAttrs (prev.lib.const {
      name = "${pname}-vendor.tar.gz";
      inherit src;
      outputHash = "sha256-d+esvz5ZpsgK+RFih0aXM4Aiwq5KJ/TIhOIf5iBQEN8=";
    });

    patches = [];
  });
}
