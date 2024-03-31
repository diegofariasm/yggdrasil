{
  stdenvNoCC,
  fetchFromGitHub,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "icomoon";
  version = "0ca39cb40b86afc29ed0295be719b3ca124821da";

  src = fetchFromGitHub {
    owner = "diegofariasm";
    repo = "icomoon";
    rev = version;
    fetchSubmodules = false;
    sha256 = "sha256-hOWs/3lesFhRsd8mmMlqZ7vkSNwtI9v8k/xj9Xpyr9E=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype

    cp */*.ttf $out/share/fonts/truetype/
  '';
}
