{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      git
      maiden
      zelda
      flavours
    ];
  };
}
