{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/2631b0b7abcea6e640ce31cd78ea58910d31e650";
    zine = {
      url = "github:kristoff-it/zine";
    };
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
        web = pkgs.callPackage ./default.nix { zine = inputs.zine.packages.${pkgs.system}.zine; };
        default = self.packages.${pkgs.system}.web;
      });
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = [ inputs.zine.packages.${pkgs.system}.zine ];
        };
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
