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
      enable = true;
      package = pkgs.vscode;
      extensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          jnoortheen.nix-ide
      ];
    };
  };
}
