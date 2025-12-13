{
  description = "CachyOS Kernel Module with BBRv3 Network Optimization";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # CachyOS stable 使用 nyxpkgs-unstable 分支
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs = { self, nixpkgs, chaotic, ... }: {
    nixosModules = {
      default = {
        imports = [
          chaotic.nixosModules.nyx-cache
          chaotic.nixosModules.nyx-overlay
          chaotic.nixosModules.nyx-registry
          ./default.nix
        ];
      };
    };
  };
}
