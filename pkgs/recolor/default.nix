{
  lib,
  fetchFromGitHub,
  python310Packages,
}:
python310Packages.buildPythonApplication rec {
  pname = "recolor";
  version = "48623031e3106261093723cd536a4dae74309c5d";

  src = fetchFromGitHub {
    owner = "enmeei";
    repo = "recolor";
    rev = version;
    hash = "sha256-ucwo5DOMUON9HgQzXmh39RLQH4sWtSfYH7+UWfGIJCo=";
  };

  propagatedBuildInputs = with python310Packages; [
    pillow
  ];

  doCheck = false;
}
