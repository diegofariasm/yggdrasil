{
  stdenvNoCC,
  fetchurl,
  undmg,
  p7zip,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "san-francisco-mono";

  buildInputs = [undmg p7zip];

  src = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg";
    sha256 = "sha256-tZHV6g427zqYzrNf3wCwiCh5Vjo8PAai9uEvayYPsjM=";
  };

  unpackPhase = ''
    undmg $src
    7z x 'SF Mono Fonts.pkg'
    7z x 'Payload~'
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 Library/Fonts/*.otf -t $out/share/fonts/opentype
    runHook postInstall
  '';
}
