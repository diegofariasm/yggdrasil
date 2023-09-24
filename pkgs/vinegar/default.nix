{ lib
, buildGoModule
, fetchFromGitHub
, wine
, symlinkJoin
, makeWrapper
}:

let
  version = "1.4.2";

  unwrapped = buildGoModule rec {
    pname = "vinegar";

    inherit version;

    src = fetchFromGitHub {
      owner = "vinegarhq";
      repo = "vinegar";
      rev = "v${version}";
      hash = "sha256-K/jxCBOcmGb5uU8F/XV5Gz0R8ZsBqKzLde3d2tKbnwA=";
    };

    vendorHash = null;

    makeFlags = [
      "PREFIX=$(out)"
      "VERSION=${version}"
    ];

    buildPhase = ''
      runHook preBuild
      make $makeFlags
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      make install $makeFlags
      runHook postInstall
    '';
  };

in
symlinkJoin {
  name = "vinegar";
  paths = [ unwrapped ];
  buildInputs = [ makeWrapper ];
  meta = with lib; {
    description = "An open-source, minimal, configurable, fast bootstrapper for running Roblox on Linux";
    homepage = "https://github.com/vinegarhq/vinegar";
    changelog = "https://github.com/vinegarhq/vinegar/releases/tag/v${version}";
    mainProgram = "vinegar";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
  postBuild = ''
    wrapProgram $out/bin/vinegar \
      --prefix PATH : ${lib.makeBinPath [ wine ]}
  '';
}
