# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];
  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "sd_mod" "rtsx_pci_sdmmc" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" =
      {
        device = "/dev/disk/by-label/nixos-root";
        fsType = "ext4";
      };

    "/home" =
      {
        device = "/dev/disk/by-label/nixos-home";
        fsType = "ext4";
      };

    "/boot" =
      {
        device = "/dev/disk/by-label/nixos-boot";
        fsType = "vfat";
      };
  };
  swapDevices = [
    { device = "/dev/disk/by-label/nixos-swap"; }
  ];

  networking.interfaces.enp1s0f1.useDHCP = lib.mkDefault true;
  networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

