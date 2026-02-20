{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation (finalAttributes: {
  pname = "noita-entangled-worlds";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "IntQuant";
    repo = "noita_entangled_worlds";
    rev = "v${finalAttributes.version}";
    hash = "sha256-iCjqqRnBuqaRmpABbouMR82au5LhnYWooJ+JnjQEUc4=";
  };
})
