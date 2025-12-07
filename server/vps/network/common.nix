{ 
    interface ? "eth0", 
    ipv4 ? null, 
    ipv6 ? null, 
    enableDhcpV4 ? false, 
    enableDhcpV6 ? false, 
    nameservers ? [ 
        "1.1.1.1" 
        "8.8.8.8" 
        "2606:4700:4700::1111" 
        "2001:4860:4860::8888" 
    ] 
}:
{ lib, config, ... }:
let
  hasIpv4 = ipv4 != null;
  hasIpv6 = ipv6 != null;
  isDhcp = (!hasIpv4 && !hasIpv6) || enableDhcpV4 || enableDhcpV6;
in
{
  networking = {
    inherit nameservers;
    useDHCP = isDhcp;
    networkmanager.enable = isDhcp;
    interfaces.${interface} = {
      useDHCP = isDhcp;
      ipv4.addresses = lib.mkIf hasIpv4 [ { address = ipv4.address; prefixLength = ipv4.prefixLength; } ];
      ipv6.addresses = lib.mkIf hasIpv6 [ { address = ipv6.address; prefixLength = ipv6.prefixLength; } ];
    };
    
    defaultGateway = lib.mkIf (hasIpv4 && ipv4 ? gateway) ipv4.gateway;
    defaultGateway6 = lib.mkIf (hasIpv6 && ipv6 ? gateway) { address = ipv6.gateway; interface = interface; };
  };
}
