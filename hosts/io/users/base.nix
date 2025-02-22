{user, ...}: {
  home = {
    username = user.username;
    homeDirectory = "/home/${user.username}";
  };
}
