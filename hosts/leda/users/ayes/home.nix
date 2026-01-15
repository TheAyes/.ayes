{
  user,
  pkgs,
  system,
  inputs,
  ...
}: {
  imports = [
    #../../../../users/ayes/home.nix
  ];

  dconf.enable = false;

  home.packages = with pkgs; [
    bun
  ];
}
