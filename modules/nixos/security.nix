{ config, lib, ... }:
{
  ## System security tweaks

  # Prevent replacing the running kernel w/o reboot
  security.protectKernelImage = true;

  # tmpfs = /tmp is mounted in ram. Doing so makes temp file management speedy
  # on ssd systems, and volatile! Because it's wiped on reboot.
  boot.tmp.useTmpfs = lib.mkDefault true;

  # If not using tmpfs, which is naturally purged on reboot, we must clean it
  # /tmp ourselves. /tmp should be volatile storage!
  boot.tmp.cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);

  boot = {
    kernelModules = [
      "tcp_bbr"
    ];
    # Fix a security hole in place for backwards compatibility. See desc in
    # nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
    loader.systemd-boot.editor = false;
  };

  # So we don't have to do this later...
  security.acme.acceptTerms = true;
}
