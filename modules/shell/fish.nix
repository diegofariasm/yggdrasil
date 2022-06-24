{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.fish;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.fish = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      fish
      starship
      exa
    ];

     #home.configFile = {
     #  "fish".source = "${configDir}/fish";
     #};

  };
}
