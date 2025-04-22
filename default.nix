{
  lib,
  stdenvNoCC,
  zine,
}:
stdenvNoCC.mkDerivation {
  pname = "ssree.dev";
  version = "0.0.1";
  src = ./.;
  nativeBuildInputs = [ zine ];
  buildPhase = ''
    zine release
  '';
  installPhase = ''
    mkdir -p $out
    cp -r public/* $out
  '';
}
