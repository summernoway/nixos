{ config, pkgs, ... }:

{
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    enableWsi = true;
    capSysNice = true;
  };

  environment.systemPackages = with pkgs; [
    protonup-qt
  ];

  programs.steam.extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];
}
