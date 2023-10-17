{ lib, config, pkgs, inputs, modulesPath, ... }:

# Since this will be exported as an installer ISO, you'll have to keep in mind
# about the added imports from nixos-generators. In this case, it simply adds
# the NixOS installation CD profile.
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-base.nix"
  ];

  isoImage = {
    isoBaseName = config.networking.hostName;

    # Put the source code somewhere easy to see.
    contents = [
      {
        source = inputs.self;
        target = "/etc/nixos";
      }
    ];
  };
  modules = {
    desktop = {
      hyprland.enable = true;
      display = {
        gdm.enable = true;
      };
    };
    services = {
      ssh.enable = true;
    };
  };
}
