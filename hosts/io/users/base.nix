{
  user,
  pkgs,
  ...
}:
{
  home = {
    #username = user.username;
    #homeDirectory = "/home/${user.username}";
  };

  programs = {
    package = pkgs.btop-rocm;
  };
}
