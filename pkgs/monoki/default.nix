{
  stdenvNoCC,
  fetchzip,
  ...
}: let
  version = "1.6";
in
  stdenvNoCC.mkDerivation rec {
    pname = "monoki";
    inherit version;

    src = fetchzip {
      url = "https://github.com/madmalik/mononoki/releases/download/${version}/mononoki.zip";
      stripRoot = false;
      sha256 = "sha256-HQM9rzIJXLOScPEXZu0MzRlblLfbVVNJ+YvpONxXuwQ=";
    };

    installPhase = ''
      runHook preInstall

      install -Dm644 *.otf -t $out/share/fonts/opentype
      install -Dm644 *.ttf -t $out/share/fonts/truetype

      runHook postInstall
    '';
  }
