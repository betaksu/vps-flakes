# nix run github:nix-community/disko -- --mode disko --flake .#my-machine
# nixos-install --flake .#my-machine
{
  description = "My NixOS Flake Configuration";

  # 1. Inputs: 定义软件源
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";
  };

  # 2. Outputs: 定义构建产物
  outputs = { self, nixpkgs, disko, nixos-facter-modules, ... }@inputs:
    let
      commonArgs = {
        inherit inputs;
        inherit disko;
        inherit nixos-facter-modules;
      };

      # 接收一个属性集作为参数：
      # { system, diskDevice, extraModules }
      mkSystem = { system, diskDevice, extraModules }: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = commonArgs // { inherit diskDevice; };
        modules = [
          # 基础模块
          ./disk/auto-resize.nix
          nixos-facter-modules.nixosModules.facter
        ] ++ extraModules;
      };
    in
    {
      nixosConfigurations = {
        tohu = mkSystem {
          system = "x86_64-linux";
          diskDevice = "/dev/sda";
          extraModules = [
            ./server/vps/platform/generic.nix
            (import ./server/vps/auth/default.nix {
              # 注意：这是 "initial" 密码，仅在第一次部署时生效。
              # 以后如果你用 passwd 命令改了密码，这个配置不会覆盖它（这是为了安全性）。
              # 使用 nix run nixpkgs#mkpasswd -- -m sha-512 生成密码
              initialHashedPassword = "$6$DhwUDApjyhVCtu4H$mr8WIUeuNrxtoLeGjrMqTtp6jQeQIBuWvq/.qv9yKm3T/g5794hV.GhG78W2rctGDaibDAgS9X9I9FuPndGC01";
              
              authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBaNS9FByCEaDjPOUpeQZg58zM2wD+jEY6SkIbE1k3Zn ed25519 256-20251206 shaog@duck.com" ];
            })
            (import ./server/vps/network/static-ipv4.nix {
                interface = "eth0";
                address = "66.235.104.29";
                prefixLength = 24;
                gateway = "66.235.104.1";
            })
            ./disk/vps/Swap-2G.nix
            {
              networking.hostName = "tohu";
              facter.reportPath = ./facter/tohu.json;
              system.stateVersion = "25.11";
            }
          ];
        };

        hyperv = mkSystem {
          system = "x86_64-linux";
          diskDevice = "/dev/sda";
          extraModules = [
            ./server/vps/platform/generic.nix
            (import ./server/vps/auth/permit_passwd.nix {
              # 注意：这是 "initial" 密码，仅在第一次部署时生效。
              # 以后如果你用 passwd 命令改了密码，这个配置不会覆盖它（这是为了安全性）。
              # 使用 nix run nixpkgs#mkpasswd -- -m sha-512 生成密码
              initialHashedPassword = "$6$DhwUDApjyhVCtu4H$mr8WIUeuNrxtoLeGjrMqTtp6jQeQIBuWvq/.qv9yKm3T/g5794hV.GhG78W2rctGDaibDAgS9X9I9FuPndGC01";
              
              authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBaNS9FByCEaDjPOUpeQZg58zM2wD+jEY6SkIbE1k3Zn ed25519 256-20251206 shaog@duck.com" ];
            })
            (import ./server/vps/network/dhcp.nix)
            ./disk/vps/Swap-4G.nix
            {
              networking.hostName = "hyperv";
              facter.reportPath = ./facter/hyperv.json;
              system.stateVersion = "25.11"; 
            }
          ];
        };
      };
    };
}