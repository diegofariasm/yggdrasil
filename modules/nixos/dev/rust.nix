{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  devCfg = config.modules.dev;
  cfg = devCfg.rust;
in
{
  options.modules.dev.rust = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };


  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        rustc
        clippy
        rustfmt
        rust-analyzer

        # Builder
        cargo
        cargo-deps
        cargo-machete
        cargo-release
      ];
    })

    (mkIf cfg.xdg.enable {
      environment.sessionVariables = {
        RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
        CARGO_HOME = "$XDG_DATA_HOME/cargo";
        PATH = [ "$CARGO_HOME/bin" ];
      };
    })

  ];
}
