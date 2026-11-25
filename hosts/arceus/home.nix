{ config, pkgs, ... }:

{
  imports = [
    ./../../modules/home
  ];

  disabledModules = [
    ./../../modules/home/firefox.nix
    ./../../modules/home/hyprland.nix
  ];

  home.username = "summer";
  home.homeDirectory = "/home/summer";
  home.stateVersion = "26.05";
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        nc = "sudo vim /etc/nixos";
        nrs = "sudo nixos-rebuild switch --flake /etc/nixos/.#arceus";
        nrsu = "sudo nix flake update && sudo nixos-rebuild switch --flake /etc/nixos.#arceus";
      };
    };
  };
}
