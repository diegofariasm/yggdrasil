final: prev: {
  # Note to future self: you should always be using the *-unwrapped version
  # of the package for thse overlays. Else, everything seems to be dandy but then you
  # don't actually get the version of the package that you overlayed but the kakoune-unwrapped.
  diegofariasm-kak-lsp = prev.kak-lsp.overrideAttrs (old: rec {
    pname = "diegofariasm-kak-lsp";
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
      outputHash = "sha256-YmhjpecdXM3eF7OFbns7sARxBCY+cPdxPAf1MaA3Uc0=";
    });

    patches = [];
  });
}
