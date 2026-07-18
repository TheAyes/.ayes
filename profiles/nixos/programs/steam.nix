{ lib, pkgs, ... }:
{
  programs = {
    steam = {
      enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
        dwproton-bin
      ];

      remotePlay.openFirewall = lib.mkDefault true;
      protontricks.enable = lib.mkDefault true;
      gamescopeSession.enable = true;
    };

    gamescope = {
      enable = true;
      #capSysNice = true;
    };
  };
}
