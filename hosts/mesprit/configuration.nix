# description: summer's gaming pc/workstation
{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./../../modules/desktop
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mesprit";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  # default locale
  i18n.defaultLocale = "en_GB.UTF-8";

  # define user accounts & associated parameters. other users are created by services if modules are enabled
  users = {
      users.summer = {
      isNormalUser = true;
      extraGroups = [ "wheel" "jellyfin" ];
      packages = with pkgs; [
        tree
      ];
    };
  };

  # packages installed system wide
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    btop
    cifs-utils
    hyfetch
    p7zip
    p7zip-rar
  ];

  # some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # OpenSSH configuration.
  services.openssh.enable = true;

  # Open ports in the firewall. 22 for ssh, rest required for NFSv3 support, because windows is garbage. Other ports are enabled per-module
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ 22 ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # do not change. defines the version of the configuration language, rather than the OS
  system.stateVersion = "26.05";

}
