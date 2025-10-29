{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
  };
  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      formatter."${system}" = pkgs.nixfmt-tree;
      devShells."${system}".default = pkgs.mkShell {
        packages = with pkgs; [
          opentofu
          nixos-anywhere
          openssh
        ];
      };
      packages."${system}".default = pkgs.writeShellApplication {
        name = "init";
        text = pkgs.lib.readFile ./init.sh;
      };
    };
}
