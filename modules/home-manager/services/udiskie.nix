{ config, lib, ... }:

let
  cfg = config.modules.services.udiskie;
in
{
  options.modules.services.udiskie = {
    enable = lib.mkOption {
      description = ''
        Wheter to install zsh.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    # Note: make sure you also have udisk enabled on nixos.
    # If you don't, this service will fail.
    services = {
      udiskie = {
        enable = true;

        # No need for notifications.
        # I know it was mounted, don't worry.
        notify = false;

        # Mount the drives on connection
        # Could be annoying, might turn it off later.
        automount = true;

        # This seems to cause an error
        tray = "never";
      };
    };

  };
}
