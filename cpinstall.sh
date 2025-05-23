#!/bin/bash
#
# UnderHost cPanel Management Suite 2025
# Twitter: @UnderHost
# Website: https://underhost.com
# License: GNU GPLv3

VERSION="2025.1"
CONFIG_FILE="/etc/underhost/cpanel.conf"
LOG_FILE="/var/log/underhost_cpanel.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# UnderHost 2025 Banner
show_banner() {
  clear
  echo -e "${PURPLE}"
  echo "[+]-----------------------------------------------------------------------------[+]"
  echo -e "\e[0;35m            _|_|_|    _|_|_|                        _|                _|  _|\e[0m";
  echo -e "\e[0;35m    _|_|_|  _|    _|    _|    _|_|_|      _|_|_|  _|_|_|_|    _|_|_|  _|  _|\e[0m";
  echo -e "\e[0;35m  _|        _|_|_|      _|    _|    _|  _|_|        _|      _|    _|  _|  _|\e[0m";
  echo -e "\e[0;35m  _|        _|          _|    _|    _|      _|_|    _|      _|    _|  _|  _|\e[0m";
  echo -e "\e[0;35m    _|_|_|  _|        _|_|_|  _|    _|  _|_|_|        _|_|    _|_|_|  _|  _|\e[0m";
  echo -e "\e[0;35m                                                                   \e[0m";
  echo "[+]-----------------------------------------------------------------------------[+]"
  echo -e "${NC}"
  echo -e "${CYAN}UnderHost cPanel Management Suite ${VERSION}${NC}"
  echo -e "${BLUE}https://underhost.com/cpanel.php${NC}"
  echo "------------------------------------------------------------"
  echo -e "Server: $(hostname) | $(date)"
  echo "------------------------------------------------------------"
}

# Logging function
log() {
  echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Check for root
check_root() {
  if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}Error: This script must be run as root${NC}" >&2
    exit 1
  fi
}

# Install dependencies
install_deps() {
  echo -e "${YELLOW}Installing required dependencies...${NC}"
  if command -v yum &> /dev/null; then
    yum install -y wget curl perl git unzip
  elif command -v apt-get &> /dev/null; then
    apt-get update && apt-get install -y wget curl perl git unzip
  else
    echo -e "${RED}Error: Unsupported package manager${NC}"
    exit 1
  fi
}

# Main menu
show_menu() {
  show_banner
  echo -e "${GREEN}Main Menu:${NC}"
  echo ""
  echo -e "${CYAN}cPanel Operations:${NC}"
  echo " 1) Install cPanel"
  echo " 2) Install cPanel DNSOnly"
  echo " 3) Force cPanel Update"
  echo ""
  echo -e "${CYAN}Security Enhancements:${NC}"
  echo " 4) Install CSF Firewall"
  echo " 5) Install Malware Detection Tools"
  echo " 6) Secure /tmp Partition"
  echo " 7) Change SSH Port"
  echo " 8) Disable SELinux"
  echo ""
  echo -e "${CYAN}Performance Tools:${NC}"
  echo " 9) Install hTop"
  echo "10) Install myTop"
  echo "11) Install Process Monitor"
  echo "12) Run MySQL Tuner"
  echo ""
  echo -e "${CYAN}Plugins & Addons:${NC}"
  echo "13) Install LiteSpeed"
  echo "14) Install CloudLinux"
  echo "15) Install Softaculous"
  echo "16) Install FFMPEG"
  echo ""
  echo -e "${RED}0) Exit${NC}"
  echo ""
  echo -n "Enter your choice [0-16]: "
}

# cPanel Installation
install_cpanel() {
  echo -e "${YELLOW}Starting cPanel installation...${NC}"
  log "Beginning cPanel installation"
  cd /home || exit
  wget -N http://httpupdate.cpanel.net/latest
  if sh latest; then
    log "cPanel installed successfully"
    echo -e "${GREEN}cPanel installed successfully!${NC}"
  else
    log "cPanel installation failed"
    echo -e "${RED}cPanel installation failed!${NC}"
  fi
  sleep 3
}

# CloudLinux Installation
install_cloudlinux() {
  echo -e -n "${YELLOW}Enter your CloudLinux license key: ${NC}"
  read -r cl_key
  log "Installing CloudLinux with key: $cl_key"
  
  wget http://repo.cloudlinux.com/cloudlinux/sources/cln/cpanel2cl
  if sh cpanel2cl -k "$cl_key"; then
    log "CloudLinux installed successfully"
    echo -e "${GREEN}CloudLinux installed! System will reboot in 10 seconds...${NC}"
    sleep 10
    reboot
  else
    log "CloudLinux installation failed"
    echo -e "${RED}CloudLinux installation failed!${NC}"
  fi
}

# Main function
main() {
  check_root
  install_deps
  
  while true; do
    show_menu
    read -r choice
    
    case $choice in
      1) install_cpanel ;;
      2) install_cpanel_dnsonly ;;
      3) force_cpanel_update ;;
      4) install_csf ;;
      5) install_malware_tools ;;
      6) secure_tmp ;;
      7) change_ssh_port ;;
      8) disable_selinux ;;
      9) install_htop ;;
      10) install_mytop ;;
      11) install_process_monitor ;;
      12) run_mysql_tuner ;;
      13) install_litespeed ;;
      14) install_cloudlinux ;;
      15) install_softaculous ;;
      16) install_ffmpeg ;;
      0) echo -e "${GREEN}Exiting...${NC}"; exit 0 ;;
      *) echo -e "${RED}Invalid option!${NC}"; sleep 1 ;;
    esac
  done
}

# Execute main function
main
