{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.editors.code;
in
{
  options.modules.editors.code = {
    enable = mkBoolOpt false;
  };
  config = mkIf cfg.enable {

    home.programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      # extensions = with pkgs.vscode-extensions; [
      #   jnoortheen.nix-ide # Duh
      #   pkief.material-icon-theme # Icons for the folders
      # ];
    };

    fonts.fonts = with pkgs; [
      jetbrains-mono
    ];

    home.packages = with pkgs; [
      nixpkgs-fmt
    ];
  };
}

