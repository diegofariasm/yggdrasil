{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  devCfg = config.modules.dev;
  cfg = devCfg.rust;
in
{
  options.modules.dev.rust = {
    enable = mkBoolOpt false;
  };


  config = mkIf cfg.enable {
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
  };
}
