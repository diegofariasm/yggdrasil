{
  fetchzip,
  python310Packages,
}:
python310Packages.buildPythonApplication {
  pname = "recolor";
  version = "6c22de47b8b912672dc08909dacc2598b0a091e8";

  src = fetchzip {
    url = "https://github.com/diegofariasm/recolor/archive/94b018b71298ca35d30dc573113140b5f9b6f91a.tar.gz";
    hash = "sha256-lNJ96r1qjhxTcZIqKd0W3SOJGJmqo23iD6y6CzsNFKs=";
  };

  propagatedBuildInputs = with python310Packages; [pillow tqdm colormath];
  doCheck = false;
}
