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

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    btop
    cifs-utils
    hyfetch
    p7zip
    p7zip-unrar
  ];
}
