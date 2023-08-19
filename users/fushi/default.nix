{ pkgs, ... }:


let
  user = "fushi";
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
      shell = {
        elvish.enable = true;
        direnv.enable = true;
        starship.enable = true;
      };
      desktop = {
        browsers = {
          default = "firefox";
          firefox.enable = true;
        };
        term = {
          default = {
            name = "kitty";
            command = "kitty --single-instance";
          };
          kitty.enable = true;
        };
      };
      editors = {
        emacs = {
          enable = true;
          doom.enable = true;
        };
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
