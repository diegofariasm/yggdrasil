{
  stdenvNoCC,
  fetchurl,
  undmg,
  p7zip,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "new-york";

  buildInputs = [undmg p7zip];

  src = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/NY.dmg";
    sha256 = "sha256-yYyqkox2x9nQ842laXCqA3UwOpUGyIfUuprX975OsLA=";
  };

  unpackPhase = ''
    undmg $src
    7z x 'NY Fonts.pkg'
    7z x 'Payload~'
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 Library/Fonts/*.otf -t $out/share/fonts/opentype
    install -Dm644 Library/Fonts/*.ttf -t $out/share/fonts/truetype
    runHook postInstall
  '';
}
