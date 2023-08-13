{ lib, pkgs, config, ... }:

with lib;
with lib.my;

let
  user = "diegofariasm";
in
{
  users.users."${user}" = {
    group = "users";
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = [ "wheel" ];
    description = "My work account.";
    hashedPassword = "$6$YNJGW9lqQz5ccudx$NZnn/GlUXbeoyu6mD7/LLuqVMCd4v8pDmW0xEpMLXcv9gcFqZ24NDpkJxxgCCXbLkSCBiLJ9UdqUBKll4BvAO/";
  };

}
