{ config, pkgs, ... }

{
  programs.niri = {
    enable = true;
    useNautilus = false;
    };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    xdg-desktop-portal-gnome
  ];
}
