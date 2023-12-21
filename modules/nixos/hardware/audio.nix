{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.modules.hardware.audio;
in
{
  options.modules.hardware.audio.enable = lib.my.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      audio.enable = true;
      wireplumber.enable = true;
    };
    environment.systemPackages = with pkgs; [ easyeffects alsa-tools pavucontrol ];
  };
}
