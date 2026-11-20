{ config, pkgs, ... }:
{
  imports = [
    ./../../modules/home/vim.nix
    ./../../modules/home/firefox.nix
  ];

  home.username = "summer";
  home.homeDirectory = "/home/summer";
  home.stateVersion = "26.05";
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        nc = "sudo vim /etc/nixos";
        nrs = "sudo nixos-rebuild switch --flake /etc/nixos/.#lugia";
        nrsu = "sudo nix flake update && sudo nixos-rebuild switch --flake /etc/nixos.#lugia";
      };
    };
  };
}
