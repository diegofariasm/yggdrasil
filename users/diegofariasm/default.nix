{ pkgs, ... }:


let
  user = "diegofariasm";
in
{
  users.users."${user}" = {
    group = "users";
    shell = pkgs.elvish;
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = [ "wheel" ];
    description = "My personal account.";
    hashedPassword = "$6$YNJGW9lqQz5ccudx$NZnn/GlUXbeoyu6mD7/LLuqVMCd4v8pDmW0xEpMLXcv9gcFqZ24NDpkJxxgCCXbLkSCBiLJ9UdqUBKll4BvAO/";
  };

  home-manager.users.${user} = { pkgs, config, ... }: {

    modules = {
      # TODO: make this also set the shell for the user.
      # NOTE: it is probably done through a nixos module.
      shell.elvish.enable = true;
      desktop = {
        browsers = {
          default = "firefox";
          firefox.enable = true;
        };
      };
      editors = {
        nvim = {
          enable = true;
          nyoom.enable = true;
        };
        default = "nvim";
      };
    };

    home.stateVersion = "23.11";
  };
}
