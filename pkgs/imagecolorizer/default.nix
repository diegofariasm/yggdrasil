{
  fetchzip,
  python310Packages,
}:
python310Packages.buildPythonApplication rec {
  pname = "imagecolorizer";
  version = "48623031e3106261093723cd536a4dae74309c5d";

  src = fetchzip {
    url = "https://github.com/kiddae/imagecolorizer/archive/48623031e3106261093723cd536a4dae74309c5d.tar.gz";
    hash = "sha256-ucwo5DOMUON9HgQzXmh39RLQH4sWtSfYH7+UWfGIJCo=";
  };

  propagatedBuildInputs = with python310Packages; [
    pillow
  ];
}
