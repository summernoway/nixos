{ config, pkgs, ... }:

{
  imports = [
    ./firefox.nix
    ./vim.nix
  ];
}
