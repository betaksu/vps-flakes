# 编辑此配置文件以定义系统安装内容
# 帮助文档：man configuration.nix 或 nixos-help
{ config, lib, pkgs, nixos-facter-modules, ... }:

{
  imports =
    [
      ../platform/generic.nix
      ../auth/default.nix
      nixos-facter-modules.nixosModules.facter
    ];

  facter.reportPath = ./facter/tohu.json;

  # --- 网络配置 ---
  networking = {
    hostName = "tohu";

    useDHCP = false;
    
    # 静态 IP 配置
    interfaces.eth0.ipv4.addresses = [
      {
        address = "66.235.104.29";
        prefixLength = 24;
      }
    ];
    defaultGateway = {
      address = "66.235.104.1";
      interface = "eth0";
    };
  };

  networking.networkmanager.enable = false;

  # --- 系统状态版本 ---
  # 定义首次安装时的 NixOS 版本，用于保持数据兼容性。
  # 除非你清楚后果，否则不要更改此值 (这不会影响系统升级)。
  system.stateVersion = "25.11"; 
}