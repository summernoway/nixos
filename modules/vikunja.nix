{ config, pkgs, ... }:

{
  services.vikunja = {
    enable = true;
    package = pkgs.vikunja;
    port = 3000;
    frontendScheme = "http";
    frontendHostname = "localhost";
    database = {
      type = "sqlite";
      user = "vikunja";
      path = "/var/lib/vikunja/vikunja.db";
    };
  };
}
