{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.editors.vs-code;
in {
  options.modules.editors.vs-code = {
    enable = mkBoolOpt false;
  };
  config = mkIf cfg.enable {
    home.programs.vscode =
    {
      package = pkgs.vscode-with-extensions;
      extensions = with pkgs.vscode-extensions; [
          ms-vscode.cpptools
          bbenoist.nix
      ];
    };
  };
}
