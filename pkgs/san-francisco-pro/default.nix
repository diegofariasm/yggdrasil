{
  stdenvNoCC,
  fetchurl,
  undmg,
  p7zip,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "san-francisco-pro";

  buildInputs = [undmg p7zip];

  src = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
    sha256 = "sha256-Mu0pmx3OWiKBmMEYLNg+u2MxFERK07BQGe3WAhEec5Q=";
  };

  unpackPhase = ''
    undmg $src
    7z x 'SF Pro Fonts.pkg'
    7z x 'Payload~'
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 Library/Fonts/*.otf -t $out/share/fonts/opentype
    install -Dm644 Library/Fonts/*.ttf -t $out/share/fonts/truetype
    runHook postInstall
  '';
}
