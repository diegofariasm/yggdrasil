{ pkgs, lib, config, ... }:
{
  # Timezone and other related things are defined here.
  # As i don't usually get out of my home, this is hardcoded.
  time.timeZone = lib.mkDefault "America/Sao_Paulo";
}

