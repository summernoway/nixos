{ config, pkgs, ... }:

{
  imports = [
    ./firefox.nix
    ./niri.nix
    ./steam.nix
  ];

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    btop
    cifs-utils
    alacritty
    hyfetch
    p7zip
    p7zip-rar
    pcmanfm
    feh
    discord
    mpv
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-color-emoji
  ];
}
