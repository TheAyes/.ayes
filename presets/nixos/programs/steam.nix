{ lib, pkgs, ... }: {
  programs.steam = {
    enable = true;

    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];

    remotePlay.openFirewall = lib.mkDefault true;
    protontricks.enable = lib.mkDefault true;
  };
}
