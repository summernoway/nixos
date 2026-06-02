{ config, pkgs, ... }:

{
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
    
    vim = {
      enable = true;
      defaultEditor = true;
      settings = {
        expandtab = true;
        shiftwidth = 2;
        tabstop = 2;
        number = true;
        relativenumber = true;
      };
    };
  };
}
