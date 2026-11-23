{ config, pkgs, ... }:

{
  imports = [
    ./firefox.nix
    ./vim.nix
  ];

  home.file.".config/hypr".source = ./config/hypr;
}
