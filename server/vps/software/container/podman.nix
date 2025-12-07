{ config, pkgs, lib, ... }:

{
  virtualisation.podman = {
    enable = true;
    # Docker 兼容模式 (若 Docker 同时也启用了，则禁用此兼容模式以避免冲突)
    dockerCompat = !config.virtualisation.docker.enable;
    # 启用容器间 DNS 解析 (支持容器名互访)
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
