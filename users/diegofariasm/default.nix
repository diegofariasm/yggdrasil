{ pkgs, ... }:

let
  user = "diegofariasm";
in
{
  users.users."${user}" = {
    group = "users";
    shell = pkgs.zsh;
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = [ "wheel" ];
    hashedPassword = "$6$YNJGW9lqQz5ccudx$NZnn/GlUXbeoyu6mD7/LLuqVMCd4v8pDmW0xEpMLXcv9gcFqZ24NDpkJxxgCCXbLkSCBiLJ9UdqUBKll4BvAO/";
  };

  programs.zsh.enable = true;

  home-manager.users.${user} = { pkgs, config, ... }: {

    modules = {
      shell.zsh.enable = true;
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
