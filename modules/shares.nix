# nfs server configuration to share files between my main system, my partner's system and my laptop
{ config, pkgs, ... }:

{
  # nfs share configuration
  # binds /srv/moosicgame to /export/moosicgame
  fileSystems."/export/moosicgame" = {
    device = "/srv/moosicgame";
    options = [ "bind" ];
    fsType = "none";
  };

  # configures the server
  services.nfs.server = {
    enable = true;
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
    extraNfsdConfig = '''';
    exports = ''
      /export/moosicgame  *(rw,sync,no_subtree_check)
      '';
    };

  # samba configuration
  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      # general storage/backup + media
      bebishare = {
        path = "/srv/bebishare";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "@jellyfin";
        "write list" = "@jellyfin";
        "force group" = "jellyfin";
        "create mask" = "0660";
        "directory mask" = "0770";
      };
      # smb mirror of the rhythm game share, because windows nfs client sucks
      moosicgame = {
        path = "/srv/moosicgame";
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
