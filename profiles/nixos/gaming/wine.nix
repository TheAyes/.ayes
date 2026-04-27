{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wineWow64Packages.staging
    winetricks
    #bottles
  ];
}
