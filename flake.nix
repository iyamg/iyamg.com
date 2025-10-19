{
  description = "Hugo development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        apps.dev = {
          type = "app";
          program = "${pkgs.writeShellScript "hugo-dev" ''
            export PATH=${pkgs.go}/bin:$PATH
            exec ${pkgs.hugo}/bin/hugo server
          ''}";
        };
        
        apps.default = self.apps.${system}.dev;

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            hugo
            go
          ];
        };
      });
}