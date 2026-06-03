# basic slightly hardened ssh configuration parameters
# added as a module because sometimes i might be lazy, e.g. if im testing this config in a VM
{ config, ... }:

{
  services.openssh = {
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
      AllowTcpForwarding = false;
      AllowAgentForwarding = false;
      PermitTunnel = false;
      AllowUsers = [ "summer" ];
    };
    hostKeys = [
      { type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; }
      { type = "rsa"; bits = 4096; path = "/etc/ssh/ssh_host_rsa_key"; }
    ];
  };
}
