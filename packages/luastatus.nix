{
  lib,
  stdenv,
  luajit,
  my,
  ...
}: let
  name = "luastatus";
in
  stdenv.mkDerivation {
    inherit name;

    src = fetchTarball {
      url = "https://github.com/shdown/luastatus/archive/master.tar.gz";
      sha256 = "0p9zr2vb9gq877advb5jvybx6dmqzmxqh4i7yzdr7fwvz7xzd2jv";
    };
  }
