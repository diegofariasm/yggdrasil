_final: prev: {
  yggdrasil-river = prev.river.overrideAttrs (old: {
    pname = "yggdrasil-river";
    version = "master";

    src = prev.fetchFromGitHub {
      owner = "riverwm";
      repo = "river";
      rev = "14e941bae16b1ca478c32198c131c4297157f888";
      fetchSubmodules = true;
      hash = "sha256-uACc9Cb1tSw3I0fMlEMX74NfU+Tg3It74tb+nc51AZ4=";
    };

    buildInputs =
      prev.lib.lists.remove prev.pkgs.wlroots_0_16 old.buildInputs
      ++ [
        prev.pkgs.wlroots_0_17
      ];
  });
}
