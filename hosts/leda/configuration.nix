{
  hostname,
  pkgs,
  ...
}: {
  imports = [
  ];
  system.stateVersion = "23.11";
  wsl = {
    enable = true;

    defaultUser = "ayes";

    wslConf = {
      network.hostname = hostname;
    };
  };

  environment = {
    systemPackages = with pkgs; [
    ];
  };
}
