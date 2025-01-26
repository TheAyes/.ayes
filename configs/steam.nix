{pkgs, ...}: {
  programs.steam = {
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];

    remotePlay.openFirewall = true;
    extest.enable = true;
    protontricks.enable = true;
  };
}
