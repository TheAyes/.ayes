{ pkgs, ... }: {
  hardware.amdgpu.opencl.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    rocmPackages.rocm-device-libs
    rocmPackages.hsakmt
  ];
  environment.systemPackages = [ pkgs.clinfo ];

  systemd.tmpfiles.rules =
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
          rocm-device-libs
          hsakmt
        ];
      };
    in
    [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];

  boot = {
    kernelModules = [
      "amdgpu"
    ];

    kernelPatches = [
      {
        name = "amdgpu-ignore-ctx-privileges";
        patch = pkgs.fetchpatch {
          name = "cap_sys_nice_begone.patch";
          url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
          hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
        };
      }
    ];
  };
}
