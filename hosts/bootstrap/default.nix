{ config, lib, pkgs, inputs, ... }:

# Since this will be exported as an installer ISO, you'll have to keep in mind
# about the added imports from nixos-generators. In this case, it simply adds
# the NixOS installation CD profile.
#
# This means, there will be a "nixos" user among other things.
{
  isoImage = {
    isoBaseName = config.networking.hostName;

    # Store the source code in a easy-to-locate path.
    contents = [{
      source = inputs.self;
      target = "/etc/dotfiles/";
    }];
  };

}
