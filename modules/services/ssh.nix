{ options
, config
, lib
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.ssh;
  masterKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINbtB4B8gWXqenP+SptV1fvKyZ6elCQv19t9FMKsHP9T fushi@everywhere";
in
{
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
     };

    user.openssh.authorizedKeys.keys =
      if config.user.name == "fushi"
      then [ masterKey ]
      else [ ];
  };
}
