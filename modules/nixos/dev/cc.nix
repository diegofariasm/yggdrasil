{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  devCfg = config.modules.dev;
  cfg = devCfg.cc;
in
{
  options.modules.dev.cc = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gcc
      cmake
      clang
      ninja
      libtool
      gnumake
      clang-tools
      llvmPackages.libcxx
    ];
  };

}
