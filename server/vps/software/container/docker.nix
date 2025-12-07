{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    # Set up resource limits
    daemon.settings = {
      experimental = true;
      default-address-pools = [
        {
          base = "172.30.0.0/16";
          size = 24;
        }
      ];
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
      # Optionally customize rootless Docker daemon settings
      daemon.settings = {
        dns = [ "1.1.1.1" "8.8.8.8" ];
      };
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.conf.eth0.forwarding" = 1;    # enable port forwarding
  };

  users.users.root.extraGroups = [ "docker" ];
}
