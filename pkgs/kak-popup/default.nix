{
  fetchzip,
  rustPlatform,
}: let
  version = "713bdd7596a3c2902b5b6bd2e5a262b829526e43";
in
  rustPlatform.buildRustPackage {
    pname = "kak-popup";
    inherit version;

    src = fetchzip {
      url = "https://github.com/enricozb/popup.kak/archive/${version}.tar.gz";
      sha256 = "sha256-xlJ5RAN022MeylyBcLJgApZJNwMCa4vX6doa/sG06IM=";
    };

    cargoSha256 = "sha256-IB95qjKEv5MMKDYeVY/sfIAQzqsVfNWpxUhA34kUEw8=";
  }
