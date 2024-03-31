final: prev: {
  diegofariasm-kakoune = prev.kakoune-unwrapped.overrideAttrs (old: {
    pname = "diegofariasm-kakoune";
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
