{ config, pkgs, ... }:

{
  services.vikunja = {
    enable = true;
    package = pkgs.vikunja;
    port = 3000;
    frontendScheme = "http";
    database = {
      type = "sqlite";
      user = "vikunja";
      path = "/var/db/vikunja/vikunja.db";
    };
  };
}
