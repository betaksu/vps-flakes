{ 
    address, 
    prefixLength, 
    gateway, 
    interface ? "eth0", 
    enableDhcpV4 ? false, 
    nameservers ? null 
}:
(import ./common.nix ({
  inherit interface enableDhcpV4;
  ipv6 = { inherit address prefixLength gateway; };
} // (if nameservers != null then { inherit nameservers; } else {})))
