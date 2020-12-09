{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs) pkgs;
in
with pkgs; stdenv.mkDerivation {
  name = "shell";
  buildInputs = [
    ansible
    sshpass
    kubectl
    docker
    python37Packages.docker
    python37Packages.keyring
  ];
}

