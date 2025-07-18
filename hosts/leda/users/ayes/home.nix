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
    bun
    lazygit
  ];
}
