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
  # ---------------------------------------------------------------------------
  # Nextcloud
  # ---------------------------------------------------------------------------
  services.nextcloud = {
    enable = true;

    # Pin to a specific major version. Bump this one major version at a time
    # when upgrading (e.g. nextcloud30 → nextcloud31). Never skip versions.
    package = pkgs.nextcloud33;

    # The hostname Nextcloud will be reachable at.
    # Override this in your configuration.nix or here directly.
    hostName = lib.mkDefault "nextcloud.lan";

    # Use HTTPS URLs in Nextcloud's own links.
    # Set to true if you add TLS in front later.
    https = false;

    # Maximum upload size (adjust to taste).
    maxUploadSize = "2G";

    # Let Nextcloud schedule background jobs via a systemd timer
    # rather than relying on web-cron (more reliable).
    config = {
      # Database — PostgreSQL via local Unix socket (no password needed).
      dbtype = "pgsql";

      # Admin account created on first run.
      adminuser  = "admin";
      # Path to a file containing only the admin password (no trailing newline).
      # CHANGE THIS to point at your actual secrets file before deploying.
      adminpassFile = lib.mkDefault "/etc/nextcloud-admin-pass";

      # Trusted proxies — add your reverse-proxy IP here if you add one later.
      # trustedProxies = [ "127.0.0.1" ];
    };

    # Create the PostgreSQL database and user automatically.
    database.createLocally = true;

    # ---------------------------------------------------------------------------
    # Caching — Redis for distributed file-locking + APCu for local memory cache.
    # Nextcloud's admin panel will nag you if these are absent.
    # ---------------------------------------------------------------------------
    configureRedis = true;   # Wires up the local Redis socket automatically.

    extraOptions = {
      # APCu for in-memory local cache (fast key-value, same process).
      memcache.local  = "\\OC\\Memcache\\APCu";
      # Redis for distributed locking (prevents data corruption under concurrency).
      memcache.locking = "\\OC\\Memcache\\Redis";

      # Optional: set your default phone region (uses ISO 3166-1 alpha-2).
      "default_phone_region" = "GB";

      # Recommended PHP OPcache tuning (Nextcloud admin panel suggestion).
      "php_upload_tmp_dir" = "/tmp";
    };

    # PHP settings recommended by Nextcloud's admin health check.
    phpOptions = {
      "opcache.interned_strings_buffer" = "16";
      "opcache.max_accelerated_files"   = "10000";
      "opcache.memory_consumption"      = "128";
      "opcache.save_comments"           = "1";
      "opcache.revalidate_freq"         = "1";
    };

    # ---------------------------------------------------------------------------
    # Extra apps
    # ---------------------------------------------------------------------------
    # Apps are pinned to the version bundled with your Nextcloud package,
    # so they always match your server version.
    extraApps = {
      # Deck — Kanban boards for ticketing, project tracking, and task management.
      # Cards can have labels, assignees, due dates, attachments, and comments.
      # Works well as a lightweight helpdesk / issue tracker.
      inherit (config.services.nextcloud.package.packages.apps)
        deck
        tasks      # Personal task lists (integrates with Deck)
        calendar   # Calendar (useful alongside task/ticket workflows)
        contacts;  # Address book
    };

    # Ensure the extra apps above are enabled after installation.
    extraAppsEnable = true;
  };

  # ---------------------------------------------------------------------------
  # Redis
  # ---------------------------------------------------------------------------
  # configureRedis = true (above) already sets up the connection, but we still
  # need to enable the Redis service itself.
  services.redis.servers.nextcloud = {
    enable  = true;
    # Bind to Unix socket only — no TCP exposure.
    unixSocket = "/run/redis-nextcloud/redis.sock";
    unixSocketPerm = 770;
  };

  # Give the nextcloud user access to the Redis socket.
  users.users.nextcloud.extraGroups = [ "redis-nextcloud" ];

  # ---------------------------------------------------------------------------
  # PostgreSQL
  # ---------------------------------------------------------------------------
  # database.createLocally = true (above) handles database/user creation.
  # We just need to make sure PostgreSQL itself is enabled.
  services.postgresql.enable = true;

  # ---------------------------------------------------------------------------
  # Nginx (built-in Nextcloud web server)
  # ---------------------------------------------------------------------------
  # The Nextcloud module automatically configures an nginx virtual host.
  # We open port 80 in the firewall so the instance is reachable.
  services.nginx.enable = true;

  networking.firewall.allowedTCPPorts = [ 80 ];
  # Add 443 here if you enable TLS later:
  # networking.firewall.allowedTCPPorts = [ 80 443 ];

  # ---------------------------------------------------------------------------
  # Maintenance window (optional but recommended)
  # ---------------------------------------------------------------------------
  # Run Nextcloud's background maintenance (DB optimisation, etc.) at 3 AM
  # to avoid impacting daytime users.
  services.nextcloud.extraOptions."maintenance_window_start" = 3;
}
