{lib, ...}: {
  time.timeZone = lib.mkDefault "America/Sao_Paulo";
  networking.firewall = {
    allowedUDPPorts = [3000 3001];
    allowedTCPPorts = [3000 3001];
  };
}
