_final: prev: {
  # Note to future self: you should always be using the *-unwrapped version
  # of the package for thse overlays. Else, everything seems to be dandy but then you
  # don't actually get the version of the package that you overlayed but the *-unwrapped version.
  yggdrasil-kakoune = prev.kakoune-unwrapped.overrideAttrs (_old: {
    pname = "yggdrasil-kakoune";
    version = "master";

    src = prev.fetchFromGitHub {
      owner = "mawww";
      repo = "kakoune";
      rev = "57b794ede3cae1e7c21309869a2c617481a55acf";
      sha256 = "sha256-PJjy+fyN47SrSAgLTz7xPYV6YHwlJypWzqQrDGkSo7Y=";
    };

    patches = [];
  });
}
