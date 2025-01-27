{user, ...}: {
  imports = [
    ../../configs/fish
  ];

  wayland.windowManager = {
    hyprland = {
      enable = true;

      systemd = {
        enable = true;
        enableXdgAutostart = true;
      };
    };
  };
}
