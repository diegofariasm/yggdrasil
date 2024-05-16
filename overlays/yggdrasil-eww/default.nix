_final: prev: {
  yggdrasil-eww = prev.eww.overrideAttrs (old: rec {
    pname = "yggdrasil-eww";
    version = "master";

    src = prev.fetchzip {
      url = "https://github.com/elkowar/eww/archive/master.zip";
      sha256 = "sha256-deabn4fdNmJsDxkT6bgCbwB354sUHvkuq+DcdWBU6B8=";
    };

    cargoDeps = old.cargoDeps.overrideAttrs (prev.lib.const {
      name = "${pname}-vendor.tar.gz";
      inherit src;
      outputHash = "sha256-o+XNG0761UcXmhWTBBFjX6Np4THdXFZf+MmFlQgKR4I=";
    });

    # Should fix a problem where the buttons keep the focus
    # when you press it once and then move somewhere in the bar, being activated no matter where you click.
    patches = [
      ./button-fix.patch
      ./button-submit-on-enter.patch
    ];
  });
}
