# file: flake.nix
{
  description = "My NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";
  };

  outputs = { self, ... }@inputs: {
    nixosConfigurations = import ./vps/vps.nix { inherit inputs; };
  };
}