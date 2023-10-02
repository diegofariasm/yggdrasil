{ stdenvNoCC
, fetchFromGitHub
, ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "icomoon";
  version = "7e242faa6a654df572ee2e634fd37c929f36fde3";

  src = fetchFromGitHub (
    {
      owner = "fushiii";
      repo = "icomoon";
      rev = version;
      fetchSubmodules = false;
      sha256 = "LKn6kBA6TTb6tUklzrkY0Fnw3sxyrJxUy4kf/ntZc+E=";
    }
  );

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts
    
    cp -R $src $out/share/fonts
  '';

}
