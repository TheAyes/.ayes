{
  users,
  inputs,
  ...
}: {
  useUserPackages = true;
  useGlobalPkgs = true;

  users = builtins.listToAttrs (
    builtins.map
    (user: {
      name = user.username;
      value =
        (import ./${user.username} {user = user.username;})
        // {
          home = {
            username = user.username;
            homeDirectory = "/home/${user.username}";

            stateVersion = "23.11";
          };
        };
    })
    users
  );
  extraSpecialArgs = {inherit inputs;};
}
