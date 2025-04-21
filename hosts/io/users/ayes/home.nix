{ user
, pkgs
, system
, inputs
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
    uv

    #revolt-desktop
    blockbench

    proton-pass


    inputs.zen-browser.packages.${system}.default
  ];

  programs = {
    bitwig.enable = true;
  };
}
