{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    { self, ... }@inputs:
    let
      inherit (inputs.nixpkgs) lib;
      forAllSystems =
        body: lib.genAttrs lib.systems.flakeExposed (system: body inputs.nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: {
        web = pkgs.callPackage ./default.nix { };
        default = self.packages.${pkgs.stdenv.hostPlatform.system}.web;
      });
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = with pkgs; [ zola ];
        };
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
