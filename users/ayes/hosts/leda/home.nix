{ pkgs, lib, ... }: {
  home = {
    packages = with pkgs; [ claude-code ];
    sessionPath = [ "${pkgs.icu}/lib" ];
  };

  programs.git = {
    enable = true;

    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    settings = {
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    pinentryPackage = pkgs.pinentry-curses;
  };

  services.ssh-agent.enable = true;
}
