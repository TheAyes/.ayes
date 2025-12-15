{
  programs.kitty = {
    enable = true;
    settings = {
      shell = "fish --login";
      editor = "micro";
      confirm_os_window_close = "-1 count-background";
    };
  };
}
