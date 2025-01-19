{
  users,
  inputs,
  ...
}: let
  var = builtins.trace "users" users;
in {
  useUserPackages = true;
  useGlobalPkgs = true;

  users = builtins.listToAttrs (
    builtins.map
    (user: {
      name = user.username;
      value = import ./${user.username} {inherit user;};
    })
    users
  );
  extraSpecialArgs = {inherit inputs;};
}
