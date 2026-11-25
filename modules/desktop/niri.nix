{ config, pkgs, ... }:

{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    useNautilus = false;
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-gnome
    xwayland-satellite
  ];

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
  };
}
