{pkgs, ...}: {
  imports = [
  ];
  wsl.defaultUser = "ayes";
  wsl = {
    enable = true;

    wslConf = {
      network.hostname = "leda";
    };
  };
}
