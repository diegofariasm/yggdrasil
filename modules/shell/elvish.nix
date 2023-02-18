{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.elvish;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.shell.elvish = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.elvish;

    home.packages = with pkgs; [
      my.icomoon # Starship font
    ];
    # Exa, the replacement for ls
    home.programs.exa.enable = true;
    # Starship config
    home.programs.starship = {
      enable = true;
    };
    # Direnv
    home.programs.direnv.enable = true;
    home.programs.direnv.nix-direnv.enable = true;
    # Protect nix-shell from garbage collection
    nix.extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';

  };

}
