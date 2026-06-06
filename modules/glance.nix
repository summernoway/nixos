{ config, pkgs, ... }:
{
  services.glance = {
    enable = true;
    openFirewall = true;
    settings = {
      server.port = 8888;
      server.host = "0.0.0.0";
      pages = [
        {
          name = "Home";
          columns = [
            {
              size = "small";
              widgets = [
                { type = "calendar"; }
                {
                  type = "weather";
                  location = "Rochdale, UK";
                  units = "metric";
                  hour-format = "24h";
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "search";
                  search-engine = "duckduckgo";
                  new-tab = true;
                  placeholder = "Search DuckDuckGo…";
                }
                {
                  type = "monitor";
                  title = "Services";
                  sites = [
                    {
                      title = "Jellyfin";
                      url = "http://arceus:8096";
                      icon = "si:jellyfin";
                    }
                    {
                      title = "Overseerr";
                      url = "http://arceus:5055";
                      icon = "si:overseerr";
                    }
                    {
                      title = "Radarr";
                      url = "http://arceus:7878";
                      icon = "si:radarr";
                    }
                    {
                      title = "Sonarr";
                      url = "http://arceus:8989";
                      icon = "si:sonarr";
                    }
                    {
                      title = "qBittorrent";
                      url = "http://arceus:8080";
                      icon = "si:qbittorrent";
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
