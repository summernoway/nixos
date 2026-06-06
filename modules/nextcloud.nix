# nextcloud.nix — NixOS module for a self-hosted Nextcloud instance
#
# Features:
#   - Nextcloud (latest stable, currently nextcloud30)
#   - PostgreSQL database (created locally, connected via socket)
#   - Redis caching (file locking + APCu for local cache)
#   - Nextcloud Deck app (Kanban-style ticketing / project boards)
#   - Serves on HTTP (port 80) via the built-in nginx integration
#     No reverse proxy required — suitable for direct LAN/local access.
#
# Usage:
#   Add to your configuration.nix imports:
#     imports = [ ./nextcloud.nix ];
#
#   Then set the hostname and admin password file path:
#     services.nextcloud.hostName = "nextcloud.lan";
#     services.nextcloud.config.adminpassFile = "/run/secrets/nextcloud-admin-pass";
#
# Admin password file:
#   Create a plain-text file containing only the password, e.g.:
#     echo "changeme" > /run/secrets/nextcloud-admin-pass
#     chmod 600 /run/secrets/nextcloud-admin-pass
#   Consider using agenix or sops-nix for secret management in production.

{ config, pkgs, lib, ... }:

{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud33;
    hostName = lib.mkDefault "nextcloud.lan";
    https = false;
    maxUploadSize = "2G";
    config = {
      dbtype = "pgsql";

      # Admin account created on first run.
      adminuser  = "admin";
      adminpassFile = lib.mkDefault "/etc/nextcloud-admin-pass";
      
      # Trusted proxies — add your reverse-proxy IP here if you add one later.
      # trustedProxies = [ "127.0.0.1" ];
    };

    # Create the PostgreSQL database and user automatically.
    database.createLocally = true;

    configureRedis = true;   # Wires up the local Redis socket automatically.

    settings = {
      memcache.local  = "\\OC\\Memcache\\APCu";
      memcache.locking = "\\OC\\Memcache\\Redis";
      trusted_domains = [
        "nextcloud.lan"
        "localhost"
        "127.0.0.1"
        "lugia"
        "arceus"
        "192.168.*.*"
      ];
      "default_phone_region" = "GB";

      "php_upload_tmp_dir" = "/tmp";
    };

    phpOptions = {
      "opcache.interned_strings_buffer" = "16";
      "opcache.max_accelerated_files"   = "10000";
      "opcache.memory_consumption"      = "128";
      "opcache.save_comments"           = "1";
      "opcache.revalidate_freq"         = "1";
    };

    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)
        deck
        tasks      # Personal task lists (integrates with Deck)
        calendar   # Calendar (useful alongside task/ticket workflows)
        contacts;  # Address book
    };

    extraAppsEnable = true;
  };

  services.redis.servers.nextcloud = {
    enable  = true;
    unixSocket = "/run/redis-nextcloud/redis.sock";
    unixSocketPerm = 770;
  };

  users.users.nextcloud.extraGroups = [ "redis-nextcloud" ];

  services.postgresql.enable = true;
  services.nginx.enable = true;

  networking.firewall.allowedTCPPorts = [ 80 ];
  # Add 443 here if you enable TLS later:
  # networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nextcloud.settings."maintenance_window_start" = 3;
}
