# modules/browser/edge.nix
{ options
, config
, inputs
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.browsers.nyxt;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.browsers.nyxt = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ nyxt ];
    home = {
      configFile."nyxt" = {
        source = "${configDir}/nyxt";
        recursive = true;
      };

      dataFile = {
        "nyxt/extensions/nx-kaomoji" = {
          source = inputs.nx-kaomoji-src;
          recursive = true;
        };
        "nyxt/extensions/nx-dark-reader" = {
          source = inputs.nx-dark-reader-src;
          recursive = true;
        };
        "nyxt/extensions/nx-search-engines" = {
          source = inputs.nx-search-engines-src;
          recursive = true;
        };
        "nyxt/extensions/nx-notmuch" = {
          source = inputs.nx-notmuch-src;
          recursive = true;
        };
      };
    };
  };
}
