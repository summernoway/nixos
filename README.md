# Arceus Home Server

My NixOS home media/storage server.

Note this is a low stakes personal project that is done in my own free time. Config shared for reference + for my own convenience.

## Why NixOS?

I am running my server on NixOS for a few main reasons.

1. If a failure does occur with the boot drive, then it will be **trivial to redeploy** the OS along with my configurations for programs. See instructions below.
2. It allows me to express my precise configuration in code (aka. **infrastructure-as-code**).
3. **Rollbacks**. As this is a hobby/tinkerer project, if I do mess something up then recovery is straightforward. Simply reboot into an older known working generation and get back up and running in no time.
4. **Portability**. Because of the small file size of these configuration files, I can take them and work on them anywhere. E.g. if I have some free time at work, or want to test something on a VM, I can simply deploy my configuration in a vm along with a module for the service/app I want to test, before deploying to "production".


## Modules

❄️ **backups.nix** - configuration for borg, an automated backups service. configured to back up /var/lib (application states) to big 10tb hard drive. accessible over nfs if needed.

❄️ **glance.nix** - simple "homepage"/web application for monitoring services + shortcuts to them

❄️ **hardened-ssh.nix** - hardened ssh configuration. key-only auth, fail2ban, no root login.

❄️ **jellyfin-stack.nix** - configuration for jellyfin + *arr stack + qbittorrent. automated media streaming services. all running as unprivleged jellyfin user.

❄️ **shares.nix** - configuration for NFS shares. LAN only, restricted to 192.168.x.x

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
mkdir -p /mnt/boot
mount -o umask=077 /dev/sdx (boot) /mnt/boot
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
nixos-install --flake /mnt/etc/nixos/.#arceus
reboot
```

## todo

1. I acknowledge that a big failure point of this system is the fact that there are only 2 one drives, neither of which are redundant. Purchase another 10tb hdd to ensure that the main data is redundant.
2. Get qBittorrent torrent traffic to run through AirVPN/wireguard.
3. TLS/Https for services.
