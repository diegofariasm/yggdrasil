{ config
, pkgs
, lib
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.tumbler;
in
{
  options.modules.services.tumbler = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment = {
      # These packages are meant to be used for previews.
      # They are generally the same on every file manager,
      # so we just make them available globally.
      systemPackages = with pkgs; with xfce; [
        ffmpegthumbnailer
        tumbler
      ];
    };

    # This service does something i don't know.
    # I have heard it caches the thumbnails?
    services = {
      tumbler = {
        enable = true;
      };
    };

  };
}
