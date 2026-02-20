{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos";
        type = "chafa";
        width = 10; # adjust this until it looks right

        padding = {
          right = 10;
        };
      };
    };
  };
}
