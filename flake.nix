# nix run github:nix-community/disko -- --mode disko --flake .#my-machine
# nixos-install --flake .#my-machine
{
  description = "My NixOS Flake Configuration";

  # 1. Inputs: 定义软件源，类似于 Cargo.toml 中的 [dependencies]
  inputs = {
    # 官方 NixOS 仓库
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";
  };

  # 2. Outputs: 定义构建产物
  outputs = 
  inputs@{ self, nixpkgs, disko, nixos-facter-modules, ... }: {
    nixosConfigurations = {
      tohu = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        # 将 inputs 传递给模块，这样在 configuration.nix 中可以使用 inputs.nixpkgs 等
        specialArgs = { 
          inherit inputs;
          inherit disko;
          inherit nixos-facter-modules;
        };
        
        modules = [
          ./server/vps/hosts/tohu.nix
          ./disk/vps/Swap-2G.nix
          ./disk/auto-resize.nix
        ];
      };
      hyperv = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        # 将 inputs 传递给模块，这样在 configuration.nix 中可以使用 inputs.nixpkgs 等
        specialArgs = { 
          inherit inputs;
          inherit disko;
          inherit nixos-facter-modules;
        };
        
        modules = [
          ./server/vps/hosts/hyperv.nix
          ./disk/vps/Swap-4G.nix
          ./disk/auto-resize.nix
        ];
      };
    };
  };
}
