#!/usr/bin/env bash
#
# UnderHost cPanel Management Suite 2026
# Website: https://underhost.com
# License: GNU GPLv3

set -Eeuo pipefail

VERSION="2026.2"
CONFIG_DIR="/etc/underhost"
CONFIG_FILE="${CONFIG_DIR}/cpanel.conf"
LOG_FILE="/var/log/underhost_cpanel.log"
PKG_MGR=""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

show_banner() {
  clear || true
  echo -e "${PURPLE}"
  echo "[+]-----------------------------------------------------------------------------[+]"
  echo -e "\e[0;35m            _|_|_|    _|_|_|                        _|                _|  _|\e[0m"
  echo -e "\e[0;35m    _|_|_|  _|    _|    _|    _|_|_|      _|_|_|  _|_|_|_|    _|_|_|  _|  _|\e[0m"
  echo -e "\e[0;35m  _|        _|_|_|      _|    _|    _|  _|_|        _|      _|    _|  _|  _|\e[0m"
  echo -e "\e[0;35m  _|        _|          _|    _|    _|      _|_|    _|      _|    _|  _|  _|\e[0m"
  echo -e "\e[0;35m    _|_|_|  _|        _|_|_|  _|    _|  _|_|_|        _|_|    _|_|_|  _|  _|\e[0m"
  echo "[+]-----------------------------------------------------------------------------[+]"
  echo -e "${NC}"
  echo -e "${CYAN}UnderHost cPanel Management Suite ${VERSION}${NC}"
  echo -e "${BLUE}https://underhost.com/cpanel.php${NC}"
  echo "------------------------------------------------------------"
  echo -e "Server: $(hostname) | $(date '+%Y-%m-%d %H:%M:%S %Z')"
  echo "------------------------------------------------------------"
}

ensure_dirs() {
  mkdir -p "${CONFIG_DIR}"
  touch "${LOG_FILE}" "${CONFIG_FILE}"
}

log() {
  printf '%s - %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" >>"${LOG_FILE}"
}

die() {
  echo -e "${RED}Error: $1${NC}" >&2
  log "ERROR: $1"
  return 1
}

ok() {
  echo -e "${GREEN}$1${NC}"
}

warn() {
  echo -e "${YELLOW}$1${NC}"
  log "WARN: $1"
}

run_and_log() {
  local description="$1"
  shift
  log "Starting: ${description}"
  if "$@"; then
    log "Success: ${description}"
    return 0
  fi
  log "Failed: ${description}"
  return 1
}

check_root() {
  [[ "$(id -u)" -eq 0 ]] || { die "This script must be run as root"; exit 1; }
}

detect_pkg_mgr() {
  if command -v dnf >/dev/null 2>&1; then
    PKG_MGR="dnf"
  elif command -v yum >/dev/null 2>&1; then
    PKG_MGR="yum"
  elif command -v apt-get >/dev/null 2>&1; then
    PKG_MGR="apt"
  else
    die "Unsupported package manager" || true
    exit 1
  fi
}

install_packages() {
  case "${PKG_MGR}" in
    dnf) dnf install -y "$@" ;;
    yum) yum install -y "$@" ;;
    apt) apt-get install -y "$@" ;;
  esac
}

install_deps() {
  detect_pkg_mgr
  echo -e "${YELLOW}Installing base dependencies using ${PKG_MGR}...${NC}"
  if [[ "${PKG_MGR}" == "apt" ]]; then
    apt-get update
  fi
  install_packages wget curl perl git unzip tar sed grep gawk
}

install_cpanel() {
  local installer="/home/latest"
  echo -e "${YELLOW}Starting cPanel installation...${NC}"
  run_and_log "Download cPanel installer" wget -q -O "${installer}" "https://httpupdate.cpanel.net/latest" || { die "Unable to download cPanel installer"; return; }
  chmod 700 "${installer}"
  run_and_log "Run cPanel installer" bash "${installer}" && ok "cPanel installed successfully" || die "cPanel installation failed"
}

install_cpanel_dnsonly() {
  local installer="/home/latest-dnsonly"
  echo -e "${YELLOW}Starting cPanel DNSOnly installation...${NC}"
  run_and_log "Download DNSOnly installer" wget -q -O "${installer}" "https://securedownloads.cpanel.net/latest-dnsonly" || { die "Unable to download DNSOnly installer"; return; }
  chmod 700 "${installer}"
  run_and_log "Run DNSOnly installer" bash "${installer}" && ok "cPanel DNSOnly installed successfully" || die "cPanel DNSOnly installation failed"
}

force_cpanel_update() {
  local updater="/usr/local/cpanel/scripts/upcp"
  [[ -x "${updater}" ]] || { die "cPanel updater not found at ${updater}"; return; }
  run_and_log "Forced cPanel update" "${updater}" --force && ok "cPanel update completed" || die "cPanel update failed"
}

install_csf() {
  local tmpdir
  tmpdir="$(mktemp -d)"
  echo -e "${YELLOW}Installing CSF Firewall...${NC}"
  run_and_log "Download CSF" wget -q -O "${tmpdir}/csf.tgz" "https://backup.underhost.com/mirror/configserver/csf.tgz" || { rm -rf "${tmpdir}"; die "Failed to download CSF"; return; }
  tar -xzf "${tmpdir}/csf.tgz" -C "${tmpdir}"
  run_and_log "Install CSF" bash "${tmpdir}/csf/install.sh" && ok "CSF installed" || die "CSF install failed"
  rm -rf "${tmpdir}"
}

upgrade_csf_14_to_15() {
  local script="/tmp/migrate_csf.sh"
  echo -e "${YELLOW}Upgrading CSF 14 -> 15...${NC}"
  run_and_log "Download CSF migration script" wget -q -O "${script}" "https://backup.underhost.com/mirror/configserver/migrate_csf.sh" || { die "Failed to download CSF migration script"; return; }
  chmod +x "${script}"
  run_and_log "Run CSF migration script" bash "${script}" && ok "CSF migration completed" || die "CSF migration failed"
}

install_malware_tools() {
  echo -e "${YELLOW}Installing malware detection tools...${NC}"
  case "${PKG_MGR}" in
    dnf|yum) install_packages clamav clamav-update rkhunter ;;
    apt) install_packages clamav clamav-daemon rkhunter ;;
  esac

  if run_and_log "Install Linux Malware Detect" bash -c 'curl -fsSL https://www.rfxn.com/downloads/maldetect-current.tar.gz -o /tmp/maldet.tar.gz && tar -xzf /tmp/maldet.tar.gz -C /tmp && bash /tmp/maldetect-*/install.sh'; then
    ok "Malware tools installed (ClamAV, rkhunter, Maldet)"
  else
    warn "Maldet install failed, but package-based tools were installed"
  fi
}

secure_tmp() {
  echo -e "${YELLOW}Applying /tmp mount hardening flags...${NC}"
  if mount | grep -qE ' on /tmp '; then
    if run_and_log "Remount /tmp with nodev,nosuid,noexec" mount -o remount,nodev,nosuid,noexec /tmp; then
      ok "/tmp hardening applied"
    else
      warn "Could not remount /tmp. Ensure /tmp is a separate mount and update /etc/fstab manually."
    fi
  else
    warn "/tmp is not a separate mount; skipping automatic remount"
  fi
}

change_ssh_port() {
  local new_port
  echo -n "Enter new SSH port (1024-65535): "
  read -r new_port
  [[ "${new_port}" =~ ^[0-9]+$ ]] || { die "Invalid port"; return; }
  (( new_port >= 1024 && new_port <= 65535 )) || { die "Port must be between 1024 and 65535"; return; }

  cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak.$(date +%s)
  if grep -qE '^#?Port ' /etc/ssh/sshd_config; then
    sed -i "s/^#\?Port .*/Port ${new_port}/" /etc/ssh/sshd_config
  else
    echo "Port ${new_port}" >> /etc/ssh/sshd_config
  fi

  if systemctl restart sshd 2>/dev/null || systemctl restart ssh 2>/dev/null; then
    ok "SSH port changed to ${new_port}"
  else
    die "Failed to restart SSH service; rollback from backup if needed"
  fi
}

disable_selinux() {
  if command -v getenforce >/dev/null 2>&1; then
    setenforce 0 || true
  fi
  if [[ -f /etc/selinux/config ]]; then
    sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
    ok "SELinux disabled (reboot may be required)"
  else
    warn "SELinux config file not found; nothing to change"
  fi
}

install_htop() {
  install_packages htop && ok "htop installed" || die "htop installation failed"
}

install_mytop() {
  install_packages mytop && ok "mytop installed" || die "mytop installation failed (package may not exist on this distro)"
}

install_process_monitor() {
  if install_packages btop; then
    ok "btop installed as process monitor"
  elif install_packages glances; then
    ok "glances installed as process monitor"
  else
    die "Failed to install process monitor (btop/glances)"
  fi
}

run_mysql_tuner() {
  local tuner="/tmp/mysqltuner.pl"
  run_and_log "Download MySQLTuner" curl -fsSL "https://raw.githubusercontent.com/major/MySQLTuner-perl/master/mysqltuner.pl" -o "${tuner}" || { die "Failed to download MySQLTuner"; return; }
  chmod +x "${tuner}"
  run_and_log "Run MySQLTuner" perl "${tuner}" || die "MySQLTuner execution failed"
}

install_litespeed() {
  local installer="/tmp/lsws_whm_autoinstaller.sh"
  run_and_log "Download LiteSpeed installer" curl -fsSL "https://www.litespeedtech.com/packages/cpanel/lsws_whm_autoinstaller.sh" -o "${installer}" || { die "Failed to download LiteSpeed installer"; return; }
  chmod +x "${installer}"
  run_and_log "Run LiteSpeed installer" bash "${installer}" && ok "LiteSpeed installer finished" || die "LiteSpeed install failed"
}

install_cloudlinux() {
  local cl_key cpanel2cl="/tmp/cpanel2cl"
  echo -n "Enter your CloudLinux license key: "
  read -r cl_key
  [[ -n "${cl_key}" ]] || { die "CloudLinux license key is required"; return; }

  run_and_log "Download CloudLinux migration script" wget -q -O "${cpanel2cl}" "https://repo.cloudlinux.com/cloudlinux/sources/cln/cpanel2cl" || { die "Unable to download CloudLinux migration script"; return; }
  chmod +x "${cpanel2cl}"
  run_and_log "Run CloudLinux migration" bash "${cpanel2cl}" -k "${cl_key}" && ok "CloudLinux installation complete. Reboot recommended." || die "CloudLinux installation failed"
}

install_softaculous() {
  local installer="/tmp/softaculous_install.sh"
  run_and_log "Download Softaculous installer" curl -fsSL "https://files.softaculous.com/install.sh" -o "${installer}" || { die "Failed to download Softaculous installer"; return; }
  chmod +x "${installer}"
  run_and_log "Run Softaculous installer" bash "${installer}" && ok "Softaculous installer finished" || die "Softaculous installation failed"
}

install_ffmpeg() {
  case "${PKG_MGR}" in
    dnf|yum)
      install_packages epel-release || true
      ;;
  esac
  install_packages ffmpeg ffmpeg-devel && ok "FFMPEG installed" || die "FFMPEG installation failed"
}

show_menu() {
  show_banner
  echo -e "${GREEN}Main Menu:${NC}"
  echo
  echo -e "${CYAN}cPanel Operations:${NC}"
  echo " 1) Install cPanel"
  echo " 2) Install cPanel DNSOnly"
  echo " 3) Force cPanel Update"
  echo
  echo -e "${CYAN}Security Enhancements:${NC}"
  echo " 4) Install CSF Firewall"
  echo " 5) Install Malware Detection Tools"
  echo " 6) Secure /tmp Partition"
  echo " 7) Change SSH Port"
  echo " 8) Disable SELinux"
  echo "17) Upgrade CSF 14 -> 15"
  echo
  echo -e "${CYAN}Performance Tools:${NC}"
  echo " 9) Install hTop"
  echo "10) Install myTop"
  echo "11) Install Process Monitor"
  echo "12) Run MySQL Tuner"
  echo
  echo -e "${CYAN}Plugins & Addons:${NC}"
  echo "13) Install LiteSpeed"
  echo "14) Install CloudLinux"
  echo "15) Install Softaculous"
  echo "16) Install FFMPEG"
  echo
  echo -e "${RED}0) Exit${NC}"
  echo
  echo -n "Enter your choice [0-17]: "
}

main_menu_loop() {
  local choice
  while true; do
    show_menu
    read -r choice
    case "${choice}" in
      1) install_cpanel ;;
      2) install_cpanel_dnsonly ;;
      3) force_cpanel_update ;;
      4) install_csf ;;
      5) install_malware_tools ;;
      6) secure_tmp ;;
      7) change_ssh_port ;;
      8) disable_selinux ;;
      17) upgrade_csf_14_to_15 ;;
      9) install_htop ;;
      10) install_mytop ;;
      11) install_process_monitor ;;
      12) run_mysql_tuner ;;
      13) install_litespeed ;;
      14) install_cloudlinux ;;
      15) install_softaculous ;;
      16) install_ffmpeg ;;
      0) ok "Exiting..."; exit 0 ;;
      *) die "Invalid option" || true ;;
    esac
    echo
    read -r -p "Press Enter to return to menu..." _
  done
}

main() {
  check_root
  ensure_dirs
  install_deps
  main_menu_loop
}

main "$@"
