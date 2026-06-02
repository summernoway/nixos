{ config, pkgs, ... }:

{
  # nfs share for rhythm game charts
  fileSystems."/export/moosicgame" = {
    device = "/mnt/moosicgame";
    options = [ "bind" ];
    fsType = "none";
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export/moosicgame  (rw,sync,no_subtree_check)
      '';
    };

  # samba share for general file storage + media
  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      bebishare = {
        path = "/mnt/bebishare";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "@jellyfin";
        "write list" = "@jellyfin";
        "force group" = "jellyfin";
        "create mask" = "0660";
        "directory mask" = "0770";
      };
    };
  };
}

