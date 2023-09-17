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

    # These are generally by a lof of packages.
    # So, instead of i having to wrap to be able to install them,
    # i just install it globally and use it like that. I can just override it anyway.

    hardware = {
      bluetooth.enable = true;
      audio.enable = true;
      zram.enable = true;
      fs.enable = true;
    };

    services = {
      ssh.enable = true;
      podman.enable = true;
      tumbler.enable = true;
    };
  };

  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  # networkinwireless.enable = true;
  networking.networkmanager.enable = true;

}
