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
      audio.enable = true;
      intel.enable = true;
      bluetooth.enable = true;
      fs.enable = true;
    };
    desktop = {
      dwm.enable = true;
      media = {
        vlc.enable = true;
        nomacs.enable = true;
      };
      apps = {
        thunar.enable = true;
      };
      browsers = {
        default = "firefox";
        firefox.enable = true;
      };

      term = {
        default = "st";
        st.enable = true;
      };
    };
    dev = {
      shell.enable = true;
      go.enable = true;
      node.enable = true;
      rust.enable = true;
      python.enable = true;
    };
    editors = {
      default = "code";
      vim.enable = true;
      code.enable = true;
    };
    shell = {
      git.enable = true;
      zsh.enable = true;
    };
    services = {
      ssh.enable = true;
      mate-polkit.enable = true;
    };
    theme.active = "alucard";
  };

  # TTY config
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-116n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "br-abnt2";
  };
  services.xserver = {
    layout = "br";
    autoRepeatDelay = 300;
    autoRepeatInterval = 20;
  };
  environment.variables = {
    "XKB_DEFAULT_LAYOUT" = "br";
  };
  # Enable imwheel
  services.xserver.imwheel.enable = true;
  # Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;
  networking.networkmanager.enable = true;
  # Touchpad config
  services.xserver.libinput.touchpad.naturalScrolling = true;
  services.xserver.libinput.touchpad.middleEmulation = true;
  services.xserver.libinput.touchpad.tapping = true;
  services.xserver.libinput.enable = true;
}
