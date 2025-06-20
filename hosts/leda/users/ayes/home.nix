{
  user,
  pkgs,
  system,
  inputs,
  ...
}: {
  imports = [
    ../../../../common/users/ayes/home.nix
  ];

  home.packages = with pkgs; [
    jetbrains.webstorm
    jetbrains.pycharm-professional
    jetbrains.idea-ultimate

    bun

    proton-pass

    inputs.zen-browser.packages.${system}.default
  ];
}
