{ stdenvNoCC, callPackage, fetchurl, autoPatchelfHook, unzip, openssl, lib }:
stdenvNoCC.mkDerivation rec {
  version = "0.1.7";
  pname = "bun";

  src = fetchurl {
    url = "https://github.com/Jarred-Sumner/bun-releases-for-updater/releases/download/bun-v${version}/bun-linux-x64.zip";
    #url = "https://github.com/Jarred-Sumner/bun-releases-for-updater/releases/download/bun-v0.1.7/bun-linux-x64.zip";
    sha256 = "00yyq7yjjkg8f3yblbhgvhaa10lda16k22x17gqj1yf2cnfrbj7c";
  };

  strictDeps = true;
  nativeBuildInputs = [ unzip ] ++ lib.optionals stdenvNoCC.isLinux [ autoPatchelfHook ];
  buildInputs = [ openssl ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm 755 ./bun $out/bin/bun
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://bun.sh";
    changelog = "https://github.com/Jarred-Sumner/bun/releases/tag/bun-v${version}";
    description = "Incredibly fast JavaScript runtime, bundler, transpiler and package manager – all in one";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    longDescription = ''
      All in one fast & easy-to-use tool. Instead of 1,000 node_modules for development, you only need bun.
    '';
    license = with licenses; [
      mit # bun core
      lgpl21Only # javascriptcore and webkit
    ];
    maintainers = with maintainers; [ DAlperin jk ];
    platforms = builtins.attrNames dists;
  };
}
