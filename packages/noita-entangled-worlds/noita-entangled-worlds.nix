{ stdenv, fetchzip, autoPatchelfHook, openssl, alsa-lib }:
stdenv.mkDerivation (finalAttributes: {
  pname = "noita-entangled-worlds";
  version = "1.6.2";

  src = fetchzip {
    url = "https://github.com/IntQuant/noita_entangled_worlds/releases/download/v${finalAttributes.version}/noita-proxy-linux.zip";
    hash = "sha256-08+W4uGTzVrnX4tsnoLFwvEuLPozdJbKAJZQJoqjXBA=";
    stripRoot = false;
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ openssl alsa-lib stdenv.cc.cc.lib ];

  installPhase = ''
    mkdir -p $out/bin $out/lib
    
    cp noita_proxy.x86_64 $out/bin/noita-entangled-worlds
    cp libsteam_api.so $out/lib/

    chmod +x $out/bin/noita-entangled-worlds
  '';
})
