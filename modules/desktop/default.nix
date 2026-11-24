{ config, pkgs, ... }:

{
  imports = [
    ./firefox.nix
    ./niri.nix
    ./steam.nix
  ];

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
}
