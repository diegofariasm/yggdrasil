{ stdenvNoCC
, fetchFromGitHub
, ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "icomoon";
  version = "0ca39cb40b86afc29ed0295be719b3ca124821da";

  src = fetchFromGitHub (
    {
      owner = "enmeei";
      repo = "icomoon";
      rev = version;
      fetchSubmodules = false;
      sha256 = "LKn6kBA6TTb6tUklzrkY0Fnw3sxyrJxUy4kf/ntZc+E=";
    }
  );


  installPhase = ''
    mkdir -p $out/share/fonts/truetype

    cp */*.ttf $out/share/fonts/truetype/
  '';
}
