{
  stdenvNoCC,
  fetchurl,
  undmg,
  p7zip,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "sf-arabic";

  buildInputs = [undmg p7zip];

  src = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Arabic.dmg";
    sha256 = "sha256-Vvfl9ByKww55lE3RTIx4TOEfuyVkENCMbHLYFGLhp2o=";
  };

  unpackPhase = ''
    undmg $src
    7z x 'SF Arabic Fonts.pkg'
    7z x 'Payload~'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 Library/Fonts/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}
