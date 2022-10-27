{
  stdenv
, fetchzip
}:
stdenv.mkDerivation rec {
  name = "icomoon";

  src = fetchzip {
      url = "https://github.com/fushiii/icomoon-font/archive/master.tar.gz";
      sha256 = "1qbkb5xzw7w9rda9rb3jrkgg0nfh32www9a9npx3ck9s228gma9c";
    };
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/share/fonts
      cp -R $src $out/share/fonts
    '';
  meta = {
    homepage = "https://github.com/fushiii/icomoon-font";
    description = "Custom icomoon font";
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
