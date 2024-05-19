_final: prev: {
  yggdrasil-act = prev.act.override (_old: let
    version = "master";

    src = prev.fetchzip {
      url = "https://github.com/nektos/act/archive/657a3d768c8fa092c89cb5420997d919c3962a4b.zip";
      sha256 = "sha256-z71C7kIZEOF35MxR28UYI1peLeFoAJFbNxfonAhpkxE=";
    };
  in {
    buildGoModule = args:
      prev.buildGoModule (args
        // {
          inherit src version;
          vendorHash = "sha256-GaKYy4rcMBDTxHEO4LjV6LV2aFK9IomHcyZ0pPnnGwk=";
        });
  });
}
