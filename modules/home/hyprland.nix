{ config, pkgs, ... }:

{
  home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/noctalia".source = ./config/noctalia;
  home.file.".config/alacritty".source = ./config/alacritty;

  gtk.theme = {
    name = "Gruvbox-Material-Dark";
    package = pkgs.gruvbox-material-gtk-theme;
  };
}
  
