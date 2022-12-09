{ modulesPath
, pkgs
, config
, ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  # In case of proprietary wireless drivers
  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  environment.systemPackages = with pkgs; [
    nixFlakes
    zsh
    git
  ];
}
# nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=./default.nix

