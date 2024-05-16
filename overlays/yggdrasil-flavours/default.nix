_final: prev: {
  yggdrasil-flavours = prev.flavours.overrideAttrs (old: rec {
    pname = "yggdrasil-flavours";
    version = "master";

    src = prev.fetchFromGitHub {
      owner = "diegofariasm";
      repo = "flavours";
      rev = "4434347b06b0f9750cd9fdacfe47356d0f2dc638";
      sha256 = "sha256-XZOlu5dvyD5ADQBzhsH3pzTU5NbXKjkA50dIHGqEmxg=";
    };

    cargoDeps = old.cargoDeps.overrideAttrs (prev.lib.const {
      name = "${pname}-vendor.tar.gz";
      inherit src;
      outputHash = "sha256-NPwgiv/P8MxrgFFdM7EpB2+W3MBNhyAuSyzJmJ0RJoY=";
    });
  });
}
