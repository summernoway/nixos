{ config, pkgs, ... }:

{
  imports = [
    ./backups.nix
    ./glance.nix
    ./hardened-ssh.nix
    ./jellyfin-stack.nix
    ./shares.nix
    ./vikunja.nix
  ];
}
