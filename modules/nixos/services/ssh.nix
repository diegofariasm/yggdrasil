{
  config,
  lib,
  ...
}: let
  cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh.enable = lib.my.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    programs.ssh.startAgent = true;
  };
}
