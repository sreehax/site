{
  lib,
  stdenvNoCC,
  zola,
}:
stdenvNoCC.mkDerivation {
  pname = "ssree.dev";
  version = "0.0.1";
  src = ./.;
  nativeBuildInputs = [ zola ];
  buildPhase = ''
    zola build
  '';
  installPhase = ''
    mkdir -p $out
    cp -r public/* $out
  '';
}
