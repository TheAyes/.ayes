{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings.janus = {
      HostName = "convene.chat";
      User = "ayes";
      IdentityFile = "~/.ssh/id_ed25519";
      IdentitiesOnly = true;
    };
  };
}
