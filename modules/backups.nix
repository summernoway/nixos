# configuration for borg. backs up /var/lib (application state dir) to big hdd locally. may configure remote backups eventually
{ config, pkg, ... }:

{
  services.borgbackup.jobs = {
    localBackup = {
      paths = [
        "/var/lib"
      ];
      repo = "/srv/bebishare/Summer/borgbackups";
      compression = "auto,zstd";
      encryption.mode = "none";
      startAt = "weekly";
      # retention policy
      prune = {
        keep = {
          weekly = 12;
        };
      };
    };
  };
}
