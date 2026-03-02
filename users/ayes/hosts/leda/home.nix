{ pkgs, ... }: {
  home.packages = with pkgs; [ claude-code ];

  programs.git = {
    enable = true;
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINyhtn5mvYllUOMfg4MmCNWSl1So1WQNegcWk095YccW ayes@leda";
      signByDefault = true;
    };
    settings = {
      gpg = {
        format = "ssh";
      };
    };
  };

  services.ssh-agent.enable = true;
}
