{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/shares.nix
      ./modules/jellyfin-stack.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "arceus";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # default locale
  i18n.defaultLocale = "en_GB.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.summer = {
    isNormalUser = true;
    extraGroups = [ "wheel" "jellyfin" ]; 
    packages = with pkgs; [
      tree
    ];
  };
  users.users.melody = {
    isNormalUser = true;
    extraGroups = [ "jellyfin" ];
    packages = with pkgs; [
      tree
    ];
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    btop
    cifs-utils
    hyfetch
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 111  2049 4000 4001 4002 20048 22 ];
  networking.firewall.allowedUDPPorts = [ 111  2049 4000 4001 4002 20048 22 ];

  system.stateVersion = "26.05";

}

