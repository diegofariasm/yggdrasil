{ stdenvNoCC
, lib
, fetchFromGitHub
, ...
} @ args:

stdenvNoCC.mkDerivation rec {
  pname = "san-francisco";
  version = "53ffbe571bb83dbb4835a010b4a49ebb9a32fc55";

  src = fetchFromGitHub ({
    owner = "fushiii";
    repo = "san-franciso-fonts";
    rev = version;
    fetchSubmodules = false;
    sha256 = "MPrqqXwYX9Ij4h7jiOktTyxx52p17oVKt+ZowcH6deM=";
  });

  installPhase = ''
    mkdir -p $out/share/fonts/opentype/

    cp */*.otf $out/share/fonts/opentype
  '';

  meta = with lib; {
    description =
      ''
        Apple fonts
      '';
    homepage = "https://developer.apple.com/fonts";
  };
}