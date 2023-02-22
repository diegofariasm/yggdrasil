{ pkgs }:

with pkgs.vscode-extensions; [
  # Remote development
  ms-vscode-remote.remote-ssh

  # Utils
  eamodio.gitlens
  # Formatters / Lsp
  jnoortheen.nix-ide

] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  {
    # Show errors and etc inline.
    name = "errorlens";
    publisher = "usernamehw";
    version = "3.7.0";
    sha256 = "sha256-/+bkVFI5dJo8shmJlRu+Ms3SVGsWi5g1T1V86p3Mk1U=";
  }
  {
    # What is a developer without pretty icons?
    name = "vscode-icons";
    publisher = "vscode-icons-team";
    version = "12.2.0";
    sha256 = "sha256-PxM+20mkj7DpcdFuExUFN5wldfs7Qmas3CnZpEFeRYs=";
  }
  {
    name = "andromeda";
    publisher = "EliverLara";
    version = "1.7.2";
    sha256 = "sha256-IFi+rSEb+Am5Sepav/31D+U2hYHwBrQoB40gfVSNFpM=";
  }
  {
    name = "vscode-todo-highlight";
    publisher = "wayou";
    version = "1.0.5";
    sha256 = "sha256-CQVtMdt/fZcNIbH/KybJixnLqCsz5iF1U0k+GfL65Ok=";
  }
]
