{ 
    ipv4, 
    ipv6, 
    interface ? "eth0", 
    nameservers ? null 
}:
(import ./common.nix ({
  inherit interface ipv4 ipv6;
} // (if nameservers != null then { inherit nameservers; } else {})))
