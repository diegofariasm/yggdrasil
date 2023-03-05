{ pkgs
, config
, lib
, ...
}: {
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    hardware = {
      intel.enable = true;
      fs.enable = true;
    };
    dev = {
      rust.enable = true;
      node.enable = true;
    };
    editors = {
      default = "code";
      vim.enable = true;
    };
    shell = {
      zsh.enable = true;
      git.enable = true;
      tmux.enable = true;
      direnv.enable = true;
      starship.enable = true;
    };
    services = {
      ssh.enable = true;
    };
    theme.active = "alucard";
  };
  home.packages = with pkgs; [
    gallery-dl
  ];

  # Tty config
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    keyMap = "br-abnt2";
  };

  environment.variables = {
    "XKB_DEFAULT_LAYOUT" = "br";
  };


  # hostId = "$(head -c 8 /etc/machine-id)";
  networking.hostId = "a9b7b2aa";

  # Local config
  programs.ssh.startAgent = true;
  services = {
    openssh.startWhenNeeded = true;
    xserver = {
      # Mouse configuration
      imwheel.enable = true;
      # Keyboard configuration
      layout = "br";
      autoRepeatDelay = 300;
      autoRepeatInterval = 20;
    };
  };

}
