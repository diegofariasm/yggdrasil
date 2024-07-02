{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.theme;
in {
  config = let
    enabledThemes = lib.my.countAttrs (_: module: lib.isAttrs module && builtins.hasAttr "enable" module && module.enable) cfg;
  in
    lib.mkMerge [
      (lib.mkIf
        (enabledThemes > 0)
        {
          assertions = [
            {
              assertion = enabledThemes <= 1;
              message = ''
                Only one theme should be enabled at any given time.
              '';
            }
          ];

          stylix = {
            autoEnable = true;
          };
        })
      {
        stylix = {
          enable = true;

          # As we don't have any of the available themes enabled,
          # we don't want the other things only the fonts configuration.
          autoEnable = false;

          # I don't really care about setting the wallpaper.
          image = ./default.png;

          fonts = {
            emoji = {
              package = pkgs.apple-emoji;
              name = "Apple Color Emoji";
            };
            serif = {
              package = pkgs.new-york;
              name = "New York";
            };
            sansSerif = {
              package = pkgs.san-francisco-pro;
              name = "SF Pro";
            };
            monospace = {
              package = pkgs.san-francisco-mono;
              name = "SF Mono";
            };
          };
        };
      }
    ];
}
