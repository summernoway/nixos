# configuration for borg. backs up /var/lib (application state dir) to big hdd locally. may configure remote backups eventually
{ config, pkg, ... }:

{
  services.borgbackup.jobs = {
    localBackup = {
      # paths to backup via localBackup job
      paths = [
        "/var/lib"
      ];

      # required settings configured below.
      # repo = backup location
      repo = "/srv/bebishare/Summer/borgbackups";
      compression = "auto,zstd";
      encryption.mode = "none";
      startAt = "weekly";

      # retention policy. only keep past 12 weeks of backups.
      prune = {
        keep = {
          weekly = 12;
        };
      };
    };
  };
}
