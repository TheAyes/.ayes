{ pkgs, lib, ... }:
{
  home.packages =
    with pkgs.jetbrains;

    [
      idea
      clion
      webstorm
    ];

}
