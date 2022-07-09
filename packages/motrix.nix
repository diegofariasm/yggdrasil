{fetchurl, appimageTools}:

let
  version = "1.6.11";
in
appimageTools.wrapType2 {
  name = "Motrix";
  src = fetchurl {
    url = "https://github.com/agalwood/Motrix/releases/download/v${version}/Motrix-${version}.AppImage";
    sha256 = "tE2Q7NM+cQOg+vyqyfRwg05EOMQWhhggTA6S+VT+SkM=";
  };
}
