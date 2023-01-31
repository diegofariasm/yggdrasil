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
        editing.enable = true;
        vlc.enable = true;
        nomacs.enable = true;
      };
      apps = {
        thunar.enable = true;
      };
      browsers = {
        default = "firefox";
        firefox.enable = true;
        edge.enable = true;
      };
      term = {
        default = "st";
        st.enable = true;
      };
    };
    dev = {
      shell.enable = true;
      cc.enable = true;
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
      starship.enable = true;
      git.enable = true;
      fish.enable = true;
    };
    services = {
      mate-polkit.enable = true;
      ssh.enable = true;
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
