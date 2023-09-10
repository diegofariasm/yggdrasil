{ config, lib, pkgs, ... }:

let
  cfg = config.modules.editors.code;
in
{
  options.modules.editors.code = {
    enable = lib.mkOption {
      description = ''
        Wheter to install the code package.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {

    # TODO: add vscode settings in a mutable way.
    # home.mutableFile should be the way to go.
    programs.vscode = {
      enable = true;

      # My personal extions.
      # Will add way to select them later.
      extensions = with pkgs.vscode-extensions; [
        mkhl.direnv
        bbenoist.nix
        jnoortheen.nix-ide
        tamasfe.even-better-toml
        github.vscode-github-actions
        vscode-icons-team.vscode-icons
      ];

      # Make the extensions dir mutable.
      # This will be useful because i will be
      # making the settings made by home-manager mutable.
      mutableExtensionsDir = true;
    };
  };
}
