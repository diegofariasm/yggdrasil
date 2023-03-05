{ config
, lib
, ...
}:
with lib; {
  networking.hosts =
    let
      hostConfig =
        if config.time.timeZone == "America/Sao_Paulo"
        then {
          "192.168.0.147" = [ "heimdall" ];
          "192.168.0.186" = [ "odin" ];
        }
        else { };
      hosts = flatten (attrValues hostConfig);
      hostName = config.networking.hostName;
    in
    mkIf (builtins.elem hostName hosts) hostConfig;

  ## Location config -- since Toronto is my 127.0.0.1
  time.timeZone = mkDefault "America/Sao_Paulo";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

}
