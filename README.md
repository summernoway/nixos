# Arceus Home Server

My NixOS home media/storage server.

## Modules

❄️ **backups.nix** - configuration for borg, an automated backups service. configured to back up /var/lib (application states)

❄️ **glance.nix** - simple "homepage"/web application for monitoring services + shortcuts to them

❄️ **hardened-ssh.nix** - hardened ssh configuration

❄️ **jellyfin-stack.nix** - configuration for jellyfin + *arr stack + qbittorrent. automated media streaming services.

❄️ **shares.nix** - configuration for NFS shares.

❄️ **vikunja.nix** - configuration for vikunja, a web based todo app.

## installation playbook

1. boot from nixos minimal installation media

2. partition disks as desired (e.g. using ```cfdisk```).

3. make filesystems as required
```
mkfs.fat -F 32 /dev/sdx
mkfs.xfs /dev/sdx
```
etc.

4. mount filesystems as required
```
mount /dev/sdx (root) /mnt
mount --mkdir /dev/sdx (boot) /mnt/boot
```
5. make directory /mnt/etc
```
mkdir -p /mnt/etc
```
6. clone this repo
```
git clone https://codeberg.org/summernoway/nixos.git
```
7. if required, regenerate and edit hardware-configuration.nix as required
```
nixos-generate-config --show-hardware-config >> /mnt/etc/nixos/hardware-configuration.nix
vim /mnt/etc/nixos/hardware-configuration.nix
```
8. if required, edit configuration.nix to enable/disable modules
```
vim /mnt/etc/nixos/configuration.nix
```
9. deploy nixos
```
nixos-install --flake /mnt/etc/nixos/.#lugia
reboot
```

## todo

write this todo list
