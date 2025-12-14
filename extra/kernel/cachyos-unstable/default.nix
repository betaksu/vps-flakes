{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.my.kernel.cachyos-unstable;
  # 引用 cachyos 目录下的共享 sysctl 配置
  sysctlConfig = import ./sysctl.nix;
in {
  options.my.kernel.cachyos-unstable = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "CachyOS kernel (unstable) with BBRv3 network optimization";
    };
  };

  config = mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxPackages_cachyos;

    # scx_rustland旨在将交互式工作负载优先于后台CPU密集型工作负载
    services.scx.enable = false;

    # 确保加载 BBR 模块 (对于 CachyOS 内核，tcp_bbr 即为 BBRv3)
    boot.kernelModules = [ "tcp_bbr" ];

    # 网络栈参数调优 (从 ../cachyos/sysctl.nix 导入)
    boot.kernel.sysctl = sysctlConfig;
  };
}
