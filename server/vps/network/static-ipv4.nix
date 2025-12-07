{ 
    address, 
    prefixLength, 
    gateway, 
    interface ? "eth0", 
    enableDhcpV6 ? false, 
    nameservers ? null 
}:
(import ./common.nix ({
  inherit interface enableDhcpV6;
  ipv4 = { inherit address prefixLength gateway; };
} // (if nameservers != null then { inherit nameservers; } else {})))
