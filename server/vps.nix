# file: server/vps.nix
{ inputs }:

let
  inherit (inputs) nixpkgs disko nixos-facter-modules;

  # 定义部分 (机制)
  commonArgs = {
    inherit inputs;
    inherit disko;
    inherit nixos-facter-modules;
  };

  mkSystem = { system, diskDevice, extraModules, pkgSrc ? inputs.nixpkgs }: 
    pkgSrc.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs diskDevice disko nixos-facter-modules;
        pkgs = pkgSrc; # 让模块内部也感知到这是特定版本的 pkgs
      };
      modules = [
        ./vps/disk/auto-resize.nix
        nixos-facter-modules.nixosModules.facter
      ] ++ extraModules;
    };
in
{
  # 注册部分 (策略)
  # 直接返回最终的主机 Set，而不是只返回 mkSystem 工具
  tohu = import ./vps/tohu.nix { 
    inherit mkSystem;
    pkgSrc = inputs.nixpkgs-25-11;
   };
  hyperv = import ./vps/hyperv.nix { 
    inherit mkSystem;
    pkgSrc = inputs.nixpkgs-25-11;
   };
}