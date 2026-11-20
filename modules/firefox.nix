{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "always";
      ExtensionSettings = {
        # blocks all other extensions from being installed
        "*".installation_mode = "blocked";

        # catppuccin mocha theme
        "{7aa7c68a-141f-45c9-a1c6-6e7382debbe1}" = {
          install_url = "https://addons.mozilla.org/en-GB/firefox/downloads/latest/catppuccin-mocha/latest.xpi";
          installation_mode = "force_installed";
        };

        # ublock origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/en-GB/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };

        # dark reader
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/en-GB/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };

        # bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/en-GB/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
    preferences = {
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.system.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    };
  };
}
