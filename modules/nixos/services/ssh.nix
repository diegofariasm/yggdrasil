{ config
, lib
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.ssh;
in
{
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      # You probably shouldn't have password authentication on,
      # it just isn't safe. But if you do, be unforgiving in the attempts.
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
    };
  };
}
