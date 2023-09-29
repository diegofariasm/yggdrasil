{ lib, inputs, ... }:
with lib;
with lib.my;
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix

    # The users for this host.
    (getUser "diegofariasm")
  ];

  ## Modules
  modules = {
    desktop = {
      hypr.enable = true;
      display = {
        gdm.enable = true;
      };
    };

    hardware = {
      bluetooth.enable = true;
      audio.enable = true;
      zram.enable = true;
      fs.enable = true;
    };

    services = {
      ssh.enable = true;
      docker.enable = true;
    };
  };

  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  # networkinwireless.enable = true;
  networking.networkmanager.enable = true;

}
