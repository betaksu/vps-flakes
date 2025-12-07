{ allowReboot ? false }:
{ config, pkgs, ... }:

{
  # --- 自动更新配置 ---
  system.autoUpgrade = {
    enable = true;
    dates = "04:00"; # 每天凌晨 4 点执行
    
    # 指定 Flake URI
    flake = "file:///etc/nixos#${config.networking.hostName}";
    
    # 强制更新 nixpkgs input 以获取新软件版本
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # 打印构建日志
    ];
    
    # 更新后允许重启
    inherit allowReboot;
    # 随机延迟 10 分钟重启，避免由于定时任务导致的并发高峰
    randomizedDelaySec = "10min";
  };
}
