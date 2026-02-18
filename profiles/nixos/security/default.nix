# Legacy profile - imports the split profiles for backwards compatibility
{
  imports = [
    ./sudo-nopassword.nix
    ../audio/low-latency.nix
    ../performance/desktop.nix
  ];
}
