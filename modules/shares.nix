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
  fileSystems."/export/bebishare" = {
    device = "/srv/bebishare";
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
      /export/bebishare *(rw,sync,no_subtree_check)
      '';
  };
}
