{ config
, lib
, ...
}:

 let
  cfg = config.modules.services.ssh;
in
{
  options.modules.services.ssh = {
      enable = lib.mkOption {
      
     type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      openssh = {
        enable = true;
        settings = {
          KbdInteractiveAuthentication = false;
          PasswordAuthentication = false;
        };
      };
    };
  };
}
