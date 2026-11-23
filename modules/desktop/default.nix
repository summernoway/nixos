{ config, pkgs, ... }:

{
  imports = [
    ./firefox.nix
    ./hyprland.nix
    ./steam.nix
  ];
}
