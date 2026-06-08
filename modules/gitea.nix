{ config, pkgs, ... }:

{
  services.gitea = {
    enable = true;
    package = pkgs.gitea;
    database.type = "sqlite3";
    stateDir = "/var/lib/gitea";
    user = "gitea";
    group = "gitea";
    settings = {
      server = {
        HTTP_PORT = 3000;
      };
    };
  };
}
