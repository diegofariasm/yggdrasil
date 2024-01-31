{ config, inputs, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.browsers.firefox;
in
{
  options.modules.desktop.browsers.firefox = {
    enable = lib.mkOption {
      description = ''
        Whether to install firefox.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles = {
        personal = {
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
          ] ++ (with pkgs.firefox-addons; [
            sourcegraph-for-firefox
          ]);
        };
      };
    };
  };
}
