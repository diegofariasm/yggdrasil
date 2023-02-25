{ pkgs }:

with pkgs.vscode-extensions; [
  # Remote development
  ms-vscode-remote.remote-ssh

  # Utils
  gruntfuggly.todo-tree

  # Web development

  wix.vscode-import-cost
  bradlc.vscode-tailwindcss
  formulahendry.auto-close-tag
  formulahendry.auto-rename-tag

  # Language support
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
    # What is a developer without a pretty theme?
    name = "andromeda";
    publisher = "EliverLara";
    version = "1.7.2";
    sha256 = "sha256-IFi+rSEb+Am5Sepav/31D+U2hYHwBrQoB40gfVSNFpM=";
  }
  {
    name = "vscode-highlight";
    publisher = "fabiospampinato";
    version = "1.7.2";
    sha256 = "sha256-tlxZrdZ3rbGO6SmuCkP4VHn4FGKJq8tC02XrjEbE5k0=";
  }
]
