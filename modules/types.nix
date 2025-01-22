{lib, ...}:
with lib; {
  types.user = with types;
    attrsOf {
      id = str;
      displayName = str;
      useHomeManager = bool;
      groups = listOf str;
      extraModules = attrsOf path;
    };

  types.host = with types;
    attrsOf {
      hostname = str;
      extraUsers = listOf types.user;
      stateVersion = str;
    };
}
