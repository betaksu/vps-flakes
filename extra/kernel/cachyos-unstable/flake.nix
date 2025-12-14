{
  description = "CachyOS Kernel Module (Unstable) with BBRv3 Network Optimization";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # CachyOS unstable 使用 chaotic.nixosModules.default (包含更多实验性功能)
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs = { self, nixpkgs, chaotic, ... }: {
    nixosModules = {
      default = {
        imports = [
          chaotic.nixosModules.default
          ./default.nix
        ];
      };
    };
    
    # 暴露 overlay 供外部使用
    overlays.default = chaotic.overlays.default;
    
    # 提供便捷函数用于构建测试 pkgs
    lib.makeTestPkgs = system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ chaotic.overlays.default ];
    };
  };
}
