{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.summer = {
      id = 0;
      name = "summer";
      isDefault = true;
      settings = {
        "browser.search.defaultenginename" = "ddg";
        "browser.search.order.1" = "ddg";
        "sidebar.revamp" = true;
      };
      search = {
        force = true;
        default = "ddg";
      };
    };
  };
}
