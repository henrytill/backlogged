{
  inputs = {
    opam-nix.url = "github:tweag/opam-nix";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.follows = "opam-nix/nixpkgs";
  };
  outputs = { self, flake-utils, opam-nix, nixpkgs }@inputs:
    let package = "backlogged";
    in flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        on = opam-nix.lib.${system};
        scope = on.buildOpamProject { } package ./. { ocaml-base-compiler = "4.14.1"; };
        overlay = final: prev: {};
      in {
        legacyPackages = scope.overrideScope' overlay;

        packages.default = self.legacyPackages.${system}.${package};
      });
}