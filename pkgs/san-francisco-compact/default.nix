{
  stdenvNoCC,
  fetchurl,
  undmg,
  p7zip,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "sf-compact";

  buildInputs = [undmg p7zip];

  src = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg";
    sha256 = "sha256-Mkf+GK4iuUhZdUdzMW0VUOmXcXcISejhMeZVm0uaRwY=";
  };

  unpackPhase = ''
    undmg $src
    7z x 'SF Compact Fonts.pkg'
    7z x 'Payload~'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 Library/Fonts/*.otf -t $out/share/fonts/opentype
    install -Dm644 Library/Fonts/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}
