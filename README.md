# cPInstall (Modernized Community Build)

`cPInstall` is a refreshed cPanel helper script that keeps the classic all-in-one menu while modernizing execution safety, logging, and installer sources.

## What changed in the modern build

- safer Bash defaults (`set -Eeuo pipefail`)
- package-manager detection (`dnf`, `yum`, `apt`)
- HTTPS downloads for external installer scripts
- unified logging and error helpers
- all classic menu commands now map to implemented functions

## Menu operations (1-16)

### cPanel
1. Install cPanel  
2. Install cPanel DNSOnly  
3. Force cPanel Update

### Security
4. Install CSF Firewall  
5. Install Malware Detection Tools (ClamAV, rkhunter, Maldet)  
6. Secure `/tmp` partition flags (`nodev,nosuid,noexec`)  
7. Change SSH Port  
8. Disable SELinux  
17. Upgrade CSF 14 -> 15

### Performance
9. Install hTop  
10. Install myTop  
11. Install Process Monitor (`btop`/`glances`)  
12. Run MySQL Tuner

### Plugins & Addons
13. Install LiteSpeed  
14. Install CloudLinux  
15. Install Softaculous  
16. Install FFMPEG

## Usage

```bash
chmod +x cpinstall.sh
sudo ./cpinstall.sh
```

## Paths

- Log file: `/var/log/underhost_cpanel.log`
- Config placeholder: `/etc/underhost/cpanel.conf`

## Important notes

- External installer URLs and package names can change over time; verify in staging before production.
- Some operations depend on specific distro repositories or licenses.
- CSF install source is pinned to `https://backup.underhost.com/mirror/configserver/csf.tgz`.
- CSF migration script source is `https://backup.underhost.com/mirror/configserver/migrate_csf.sh`.

## License

GPLv3. See [LICENSE](LICENSE).
