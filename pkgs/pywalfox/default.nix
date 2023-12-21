{ lib
, python310Packages
}:

python310Packages.buildPythonApplication rec {
  pname = "pywalfox";
  version = "2.8.0rc1";

  src = builtins.fetchTarball {
    url = https://test-files.pythonhosted.org/packages/89/a1/8e011e2d325de8e987f7c0a67222448b252fc894634bfa0d3b3728ec6dbf/pywalfox-2.8.0rc1.tar.gz;
    sha256 = "sha256:1b6nx3c58s0b5yqa417zqv9fy4pwf25nzhppm51xzm9f3fpr9ci1";
  };


  doCheck = false;
}
