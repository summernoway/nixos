# automated media server stack
# to do: add secrets support for API keys
{ config, pkgs, ... }:

{
  services = {
    jellyfin = {
      enable = true;
      openFirewall = true; # opens jellyfin default port (8096)

      # run as jellyfin user
      user = "jellyfin";
      group = "jellyfin";

      # specify data directories
      dataDir = "/srv/bebishare/Jellyfin/.data";
      cacheDir = "/srv/bebishare/Jellyfin/.cache";
      logDir = "/var/log/jellyfin";
      configDir = "/srv/bebishare/Jellyfin/.config";

      # hardware accel for transcoding
      hardwareAcceleration = {
        enable = true;
        type = "qsv";
        device = "/dev/dri/renderD128";
      };

      # transcoding settings
      transcoding = {
        enableHardwareEncoding = true;
        enableIntelLowPowerEncoding = true;
        enableSubtitleExtraction = false;
        enableToneMapping = true;
      };
    };

    seerr = {
      enable = true;
      package = pkgs.seerr;
      openFirewall = true;
      port = 5055;
      configDir = "/var/lib/seerr";
    };

    qbittorrent = {
      enable = true;
      package = pkgs.qbittorrent-nox;
      openFirewall = true; # defined below
      webuiPort = 8080;
      torrentingPort = 6881;
      user = "jellyfin";
    };

    prowlarr = {
      enable = true;
      package = pkgs.prowlarr;
      openFirewall = true; # 9696
      dataDir = "/var/lib/prowlarr";
    };

    radarr = {
      enable = true;
      package = pkgs.radarr;
      group = "jellyfin";
      user = "jellyfin";
      openFirewall = true; # 7878
      dataDir = "/var/lib/radarr";
    };

    sonarr = {
      enable = true;
      package = pkgs.sonarr;
      group = "jellyfin";
      user = "jellyfin";
      openFirewall = true; # 8989
      dataDir = "/var/lib/sonarr";
    };

    flaresolverr = {
      enable = true;
      package = pkgs.flaresolverr;
      openFirewall = true; # 8191
      port = 8191;
    };
  };

  # below is VPN namespace configuration for qbittorrent's torrent traffic. configured using github:Maroka-chan/VPN-confinement community flake
#  vpnNamespaces.wg = {
#    enable = false;
#    wireguardConfigFile = /. + "/secrets/defaultwg.conf";
#    allowedIngress = [
#      "192.168.0.0/24"
#    ];
#    portMappings = [
#      8080 # webui port
#    ];
#    openVPNPorts = [
#      { port = 6881; protocol = "both"; } # open torrenting ports on vpn
#    ];
#  };

  # systemd service that confines qbittorrent to the namespace configured above
#  systemd.services.qbittorrent.vpnConfinement = {
#    enable = true;
#    vpnNamespace = "wg";
#  };
}
