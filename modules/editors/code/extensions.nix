{ pkgs }:

with pkgs.vscode-extensions; [
  # Looks
  pkief.material-icon-theme

  # Remote development
  ms-vscode-remote.remote-ssh

  # Utils
  gruntfuggly.todo-tree
  christian-kohler.path-intellisense

  # Formatters / Language servers
  jnoortheen.nix-ide
  esbenp.prettier-vscode

] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  {
    name = "better-comments";
    publisher = "aaron-bond";
    version = "3.0.2";
    sha256 = "15w1ixvp6vn9ng6mmcmv9ch0ngx8m85i1yabxdfn6zx3ypq802c5";
  }
]
