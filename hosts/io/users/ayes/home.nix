{ user
, pkgs
, ...
}: {
  imports = [
    ../../../../common/users/ayes/home.nix

    ./nixcord.nix
  ];

  home.packages = with pkgs; [
    jetbrains.webstorm
    jetbrains.pycharm-professional
    jetbrains.idea-ultimate

    bun

    revolt-desktop
  ];

  programs = {
    bitwig.enable = true;
  };
}
