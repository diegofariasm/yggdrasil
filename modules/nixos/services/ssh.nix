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
    services.openssh = {
      enable = true;
      # You really shouldn't make any of this default behaviour.
      # Just use a ssh key or any other method of signing instead.
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    programs.ssh.startAgent = true;
  };
}
