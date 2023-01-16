# modules/themes/alucard/default.nix --- a regal dracula-inspired theme

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  config = mkIf (cfg.active == "alucard") (mkMerge [
    # Desktop-agnostic configuration
    

    # Desktop (X11) theming
    (mkIf config.services.xserver.enable {

      fonts = {
        fonts = with pkgs; [
          fira-code
          fira-code-symbols
          open-sans
          jetbrains-mono
          siji
          font-awesome
        ];
      };


    })
  ]);
}
