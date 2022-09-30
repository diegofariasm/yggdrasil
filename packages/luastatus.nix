{ stdenv
, fetchzip
, cmake
, pkg-config
, docutils
, xorg
, udev
, libnl
, glib
, lua
, yajl
, alsa-lib
, lib
}:
stdenv.mkDerivation rec {
  name = "luastatus";

  src = fetchzip {
    url = "https://github.com/shdown/luastatus/archive/master.tar.gz";
    sha256 = "arNwpOKyrv6ebV3Wysul7i7Qag4xEceQhk9SxB/mkQU=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ docutils xorg.xcbutil xorg.xcbutilwm xorg.libX11 udev libnl glib xorg.libXdmcp lua xorg.libxcb yajl xorg.libXau alsa-lib ];

  meta = {
    homepage = "https://github.com/shdown/luastatus";
    description = "Universal status bar content generator";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
