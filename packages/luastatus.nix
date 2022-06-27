{                                                                                                                      
  stdenv,
  fetchzip,
  cmake,
  pkgconfig,
  docutils,
  xorg,
  udev,
  libnl,
  glib,
  lua,
  yajl,
  alsa-lib,
  lib
}:
stdenv.mkDerivation rec {
  name = "luastatus";
  
  src = fetchzip {
    url = "https://github.com/shdown/luastatus/archive/master.tar.gz";
    sha256 = "08fr7pibw4pibnpb8ryi0xr6lvklrvcipzrffw1lddzkipqfjfj2";
  };
  
  nativeBuildInputs = [ cmake pkgconfig];
  buildInputs = [ docutils xorg.xcbutil xorg.xcbutilwm xorg.libX11 udev libnl glib xorg.libXdmcp lua xorg.libxcb yajl xorg.libXau alsa-lib]; 
  
  meta = {
      homepage = "https://github.com/shdown/luastatus";
      description = "Universal status bar content generator";
      license = lib.licenses.mit;
      platforms = ["x86_64-linux"];
      maintainers = [];
    };
}
