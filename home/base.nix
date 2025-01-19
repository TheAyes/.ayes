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
        (import ./${user.username} {inherit user;})
        // {
          home = {
            username = user;
            stateVersion = "23.11";
          };
        };
    })
    users
  );
  extraSpecialArgs = {inherit inputs;};
}
