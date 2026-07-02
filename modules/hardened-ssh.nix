# basic slightly hardened ssh configuration parameters
# added as a module because sometimes i might be lazy, e.g. if im testing this config in a VM
{ config, ... }:

{
  services.openssh = {
    # essentially /etc/sshd_config settings
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
      AllowTcpForwarding = false;
      AllowAgentForwarding = false;
      PermitTunnel = false;
      AllowUsers = [ "summer" ];
      LogLevel = "VERBOSE";
    };
    # defines location of host keys
    hostKeys = [
      { type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; }
      { type = "rsa"; bits = 4096; path = "/etc/ssh/ssh_host_rsa_key"; }
    ];
  };

  # fail2ban configuration
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    # whitelist
    ignoreIP = [
      "127.0.0.1/8"
      "192.168.0.0/16"
    ];
    bantime = "12h";
  };
}
