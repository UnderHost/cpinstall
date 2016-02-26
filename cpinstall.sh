#!/bin/bash
#
# Twitter.com/UnderHost
# UnderHost@ 
# Website: www.underhost.com

showMenu () {
clear
echo "";
echo "[+]-----------------------------------------------------------------------------[+]"
echo -e "\e[0;35m            _|_|_|    _|_|_|                        _|                _|  _|\e[0m";
echo -e "\e[0;35m    _|_|_|  _|    _|    _|    _|_|_|      _|_|_|  _|_|_|_|    _|_|_|  _|  _|\e[0m";
echo -e "\e[0;35m  _|        _|_|_|      _|    _|    _|  _|_|        _|      _|    _|  _|  _|\e[0m";
echo -e "\e[0;35m  _|        _|          _|    _|    _|      _|_|    _|      _|    _|  _|  _|\e[0m";
echo -e "\e[0;35m    _|_|_|  _|        _|_|_|  _|    _|  _|_|_|        _|_|    _|_|_|  _|  _|\e[0m";
echo -e "\e[0;35m                                                                   \e[0m";
echo "[+]-----------------------------------------------------------------------------[+]"
echo " ";
echo " Welcome to cPanel Setup, Secure and Plugin Install";
echo " Update build 0.3 - GNU General Public License (GPL)";
echo " cPInstall.com - underhost@users.sourceforge.net by UnderHost.com";
echo " `date`";
echo " ";
echo -e "\e[1;37m cPanel Install:\e[0m";
echo " cpanel -------------- Install latest cPanel." 
echo " cpdnsonly ----------- Install cPanel DNSOnly." 
echo " cpupdate ------------ Force cPanel update." 
echo " ";
echo -e "\e[1;37m CloudLinux Install:\e[0m";
echo " regcloudlinux ------- Register with CloudLinux Network." 
echo " cloudlinux ---------- Install CloudLinux on your system (License and Reboot required)." 
echo " ";
echo -e "\e[1;37m Plugins - Addons and Secure:\e[0m";
echo " firewall ------------ Install CSF Firewall."
echo " htopsetup ----------- Install htop Process Viewer."
echo " logview ------------- Install logview plugin." 
echo " chkrootkit ---------- Install CHKRootKit."
echo " maldetect ----------- Install Linux Malware Detect."
echo " whmsonic ------------ Install WHMSonic Plugin (License required)."
echo " fantastico ---------- Install Fantastico Plugin (License required)."
echo " softaculous --------- Install Softaculous Plugin (License required)."
echo " cpnginx ------------- Install cPnginx Plugin (License required)."
echo " litespeed ----------- Install LiteSpeed Plugin (License required)."
echo " cloudflare ---------- Install CloudFlare Plugin (Key required, Partnership required)."
echo " cleanbackup --------- Install Clean Backup Plugin."
echo " prminstall ---------- Install Process Resource Monitor."
echo " siminstall ---------- Install System Integrity Monitor."
echo " bfdetect ------------ Install Brute Force Detection."
echo " rkhunter ------------ Install rkHunter."
echo " imagick ------------- Install Imagemagick / Imagick for PHP."
echo " dnscheck ------------ Install Account DNS Check Plugin."
echo " ruby ---------------- Install Ruby on Rails."
echo " ffmpeg -------------- Install FFMPEG."
echo " nginxadmin ---------- Install Nginx Admin Plugin."
echo " mytop --------------- Install mytop 1.4."
echo " geoip --------------- Install GeoIP Apache API (mod_geoip)."
echo " allconfigserver ----- Install All Plugins from ConfigServer.com (without CSF)" 
echo " rmnginxadmin -------- Remove Nginx Admin Plugin."
echo " ffmpegremove -------- Remove FFMPEG from your system."
echo " compileon ----------- Disable Compilers."
echo " compileoff ---------- Enable Compilers."
echo " port ---------------- Change SSH port." 
echo " selinux ------------- Disable SELinux permanently." 
echo " update -------------- Fully update your system."
echo " securetmp ----------- Secure your /tmp partition."
echo " securetmpv ---------- Secure your /tmp partition on Virtuozzo VPS."
echo " fixsuphp ------------ Fix permission issue for suPHP (Advanced users only)."
echo " sqladmin ------------ Optimize MySQL Servers."
echo " sqltuner ------------ Run MySQL Servers Tuner."
echo " synctime ------------ Synchronize time on cPanel server."
echo " ";
echo " exit ---------- Leave" 
echo " ";
echo -n "Enter your function: "
}


while :
do
showMenu
read yourch
case $yourch in


cpanel ) date
cd /home
yum -y install wget perl 
wget -N http://httpupdate.cpanel.net/latest
sh latest
showMenu
;;

cpdnsonly ) date
cd /home
wget -N http://httpupdate.cpanel.net/latest-dnsonly
sh latest-dnsonly
showMenu
;;

cpupdate ) date
/scripts/upcp --force
showMenu
;;

synctime ) date
rdate -s rdate.cpanel.net
showMenu
;;

sqltuner ) date
wget https://github.com/rackerhacker/MySQLTuner-perl/blob/master/mysqltuner.pl
perl mysqltuner.pl
echo "sqltuner successfully installed!"
sleep 4
showMenu
;;

geoip ) date
cd /usr/src
wget http://geolite.maxmind.com/download/geoip/api/c/GeoIP-1.4.6.tar.gz
tar -xvzf GeoIP*
cd GeoIP*
./configure
make
make install
cd /usr/src
wget http://geolite.maxmind.com/download/geoip/api/mod_geoip2/mod_geoip2_1.2.5.tar.gz
tar -xvzf mod_geoip*
cd mod_geoip*
/usr/local/apache/bin/apxs -i -a -L/usr/src/GeoIP-1.4.6/libGeoIP -I/usr/src/GeoIP-1.4.6/lib/GeoIP -lGeoIP -c mod_geoip.c
echo "mod_geoip has been successfully installed!"
echo "Please note, you need to enable mod_geoip inside your httpd.conf with the following lines:"
echo "GeoIPEnable On"
echo "GeoIPDBFile /usr/local/share/GeoIP/GeoIP.dat"
sleep 9
showMenu
;;

cpnginx ) date
mkdir uh
cd uh
wget underhostbackup.com/update/cpanelnginx.5.0.tar.gz
tar -xzf cpanelnginx.5.0.tar.gz
cd cpanelnginx/
sh install.sh
echo "cPnginx has been successfully installed!"
echo "Login to WHM and update your license via the plugins!"
sleep 9
showMenu
;;

mytop ) date
cd /usr/local/src
wget http://underhostbackup.com/update/TermReadKey-2.30.tar.gz
tar -zxf TermReadKey-2.30.tar.gz
cd TermRead*
perl Makefile.PL
make test
make
make install
cd ..
wget http://underhostbackup.com/update/DBI-1.616.tar.gz
tar -zxf DBI-1.616.tar.gz
cd DBI*
perl Makefile.PL
make test
make
make install
cd ..
wget http://underhostbackup.com/update/mytop-1.4.tar.gz
tar -zxf mytop-1.4.tar.gz
cd mytop*
perl Makefile.PL
make test
make
make install
echo "mytop successfully installed!"
echo "Leave script and simply run “mytop” and your done!"
sleep 9
showMenu
;;

litespeed ) date
cd /usr/src; wget http://www.litespeedtech.com/packages/cpanel/lsws_whm_plugin_install.sh; chmod 700 lsws_whm_plugin_install.sh; ./lsws_whm_plugin_install.sh; rm -f lsws_whm_plugin_install.sh
echo "LiteSpeed successfully installed!"
echo "Login to WHM and click the ‘LiteSpeed Web Server’ button."
echo "Click ‘Install LiteSpeed’ and let it run through the installation procedure, this is completely automated."
sleep 9
showMenu
;;

imagick ) date
yum install ImageM* netpbm gd gd-* libjpeg libexif gcc coreutils make
wget ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz
tar zxf ImageMagick.tar.gz
cd ImageMagick-*
./configure
make
make install
cd /usr/local/src
wget http://pecl.php.net/get/imagick-2.2.2.tgz
tar zxvf ./imagick-2.2.2.tgz
cd imagick-2.2.2
phpize && ./configure
make
make test
make install
echo "Imagemagick / Imagick for PHP has been successfully installed!"
echo "imagick.so has been compiled and moved into your extensions directory specified in php.ini. Now you’ll need to add the following to php.ini and restart apache."
echo "extension=imagick.so"
sleep 9
showMenu
;;

rkhunter ) date
cd /usr/src/
wget http://sourceforge.net/projects/rkhunter/files/rkhunter/1.3.8/rkhunter-1.3.8.tar.gz/download
tar -xvzf rkhunter-1.3.6.tar.gz
cd rkhunter-1.3.6
sh installer.sh --install --layout default
echo "rkhunter successfully installed!"
echo "rkhunter successfully installed!"
sleep 4
showMenu
;;

prminstall ) date
wget http://www.rfxnetworks.com/downloads/prm-current.tar.gz
tar xvfz prm-current.tar.gz
cd prm-*/
./install.sh
echo "Process Resource Monitor successfully installed!"
sleep 4
showMenu
;;

siminstall ) date
wget http://www.rfxn.com/downloads/sim-current.tar.gz
tar xvfz sim-current.tar.gz
cd sim-*/
./install.sh
echo "System Integrity Monitor successfully installed!"
sleep 4
showMenu
;;

sqladmin ) date
cd /etc
rm -Rf my.cnf
wget http://underhostbackup.com/update/my.cnf
chmod 644 my.cnf
echo "Automated SQL Optimization Completed!"
sleep 6
showMenu
;;

cloudlinux ) echo -e "Please enter your CloudLinux key: "
read clkey
echo "Key entered: $clkey"
wget http://repo.cloudlinux.com/cloudlinux/sources/cln/cpanel2cl
sh cpanel2cl -k $clkey
echo "Successfully Installed Cloudlinux now your system is about to reboot (12 seconds)"
echo "Once you have rebooted, run: /scripts/easyapache --build "
sleep 8
echo "Once done, you are running CloudLinux kernel with LVE enabled.!"
sleep 4
reboot
showMenu
;;


cloudflare ) echo -e "Please enter your CloudFlare key: "
read cfkey
echo "Key entered: $cfkey"
echo -e "Please enter your company name setup with CloudFlare: "
read companyname
echo "Name entered: $companyname"
cd /usr/local/cpanel
curl -k -L https://github.com/cloudflare/CloudFlare-CPanel/tarball/master > cloudflare.tar.gz
tar -zxf cloudflare.tar.gz
cd cloudflare-CloudFlare-CPanel-*/cloudflare/
./install_cf $cfkey mod_cf “$companyname”
echo "Successfully Installed CloudFlare Plugin"
echo "Detail about our installation will appear now"
sleep 8
cat etc/cloudflare.json
echo "You can login to cPanel to view CloudFlare plugin enabled!"
sleep 4
showMenu
;;

regcloudlinux ) echo -e "Please enter your CloudLinux key: "
read clkey
echo "Key entered: $clkey"
yum install rhn-setup
rhnreg_ks --activationkey=$clkey --force
lvectl ubc enable -save
echo "Successfully Registered to CloudLinux Network (CLN)!"
sleep 5
showMenu
;;

fixsuphp ) echo -e "Please enter cPanel username you want to fix: "
read cpusername
echo "Update are done on: $cpusername"
cd /home/$cpusername/public_html
chown -R $cpusername:$cpusername *
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;
echo "Permission has been modified to 644 on files and 755 for folders!"
echo "Each files has been also chown to user: $cpusername!"
sleep 6
showMenu
;;

whmsonic ) date
cd /root/; wget http://www.whmsonic.com/setupr/installr.sh; chmod +x installr.sh; ./installr.sh
echo "WHMSonic successfully installed!"
sleep 5
showMenu
;;

ruby ) date
/scripts/installruby
gem install rails
gem install mongrel
gem install fastthread
echo "Ruby on Rails successfully installed!"
echo "Open ports 3000 and 12001 if you’re running a firewall"
sleep 8
showMenu
;;

ffmpeg ) date
wget http://mirror.ffmpeginstaller.com/old/scripts/ffmpeg7/ffmpeginstaller.7.1.tar.gz
tar xf ffmpeginstaller.7.1.tar.gz
cd ffmpeginstaller.7.1
./install
echo "FFMPEG successfully installed!"
sleep 4
showMenu
;;

ffmpegremove ) date
rm -Rf /usr/local/cpffmpeg
echo "FFMPEG successfully removed!"
sleep 4
showMenu
;;

nginxadmin ) date
cd /usr/local/src
wget http://nginxcp.com/nginxadmin2.7-stable.tar
tar xf nginxadmin2.7-stable.tar
cd publicnginx
./nginxinstaller install
echo "cPnginx Admin Plugin successfully installed!"
sleep 4
showMenu
;;

rmnginxadmin ) date
cd /usr/local/src
wget http://nginxcp.com/nginxadmin2.7-stable.tar
tar xf nginxadmin2.7-stable.tar
cd publicnginx
./nginxinstaller uninstall
echo "cPnginx Admin Plugin successfully removed from your system!"
sleep 4
showMenu
;;

cleanbackup ) date
cd /home
rm -f latest-cleanbackups
wget http://www.ndchost.com/cpanel-whm/plugins/cleanbackups/download.php
sh latest-cleanbackups
echo "Clean Backup Plugin successfully installed!"
sleep 4
showMenu
;;

dnscheck ) date
cd /home
rm -f latest-accountdnscheck
wget http://www.ndchost.com/cpanel-whm/plugins/accountdnscheck/download.php
sh latest-accountdnscheck
echo "Account DNS Check plugin successfully installed!"
sleep 4
showMenu
;;

softaculous ) date
cd /usr/local/cpanel/whostmgr/docroot/cgi 
wget -N http://www.softaculous.com/ins/addon_softaculous.php
chmod 755 addon_softaculous.php
echo "Go to WHM, login as root and click on Tweak Settings, then you should ensure that both the Ioncube loader is selected for the backend copy of PHP. Save changes."
echo "Go to WHM, Plugins > Softaculous - Instant Installs - webpage will open if the installation was successful."
sleep 8
showMenu
;;

fantastico ) date
cd /usr/local/cpanel/whostmgr/docroot/cgi 
wget -N http://files.betaservant.com/files/free/fantastico_whm_admin.tgz
tar -xzpf fantastico_whm_admin.tgz 
rm -rf fantastico_whm_admin.tgz
echo "Go to WHM, login as root and click on Tweak Settings, then you should ensure that both the Ioncube loader is selected for the backend copy of PHP. Save changes."
echo "Go to WHM, Plugins > Fantastico - you will be able to complete installation from there."
sleep 8
showMenu
;;

compileon ) date
chmod 755 /usr/bin/perlcc
chmod 755 /usr/bin/byacc
chmod 755 /usr/bin/yacc
chmod 755 /usr/bin/bcc
chmod 755 /usr/bin/kgcc
chmod 755 /usr/bin/cc
chmod 755 /usr/bin/gcc
chmod 755 /usr/bin/i386*cc
chmod 755 /usr/bin/*c++
chmod 755 /usr/bin/*g++
chmod 755 /usr/lib/bcc /usr/lib/bcc/bcc-cc1
chmod 755 /usr/i386-glibc21-linux/lib/gcc-lib/i386-redhat-linux/2.96/cc1
echo "Compiler has been enabled, don't forget to disabled them after update."
sleep 4
showMenu
;;

compileoff ) date
chmod 000 /usr/bin/perlcc
chmod 000 /usr/bin/byacc
chmod 000 /usr/bin/yacc
chmod 000 /usr/bin/bcc
chmod 000 /usr/bin/kgcc
chmod 000 /usr/bin/cc
chmod 000 /usr/bin/gcc
chmod 000 /usr/bin/i386*cc
chmod 000 /usr/bin/*c++
chmod 000 /usr/bin/*g++
chmod 000 /usr/lib/bcc /usr/lib/bcc/bcc-cc1
chmod 000 /usr/i386-glibc21-linux/lib/gcc-lib/i386-redhat-linux/2.96/cc1
echo "Compiler has been disabled, don't forget to enabled them to do update."
sleep 4
showMenu
;;

securetmp ) date
/scripts/securetmp
echo "tmp partition has been mounted to a temporary file for extra security."
sleep 4
showMenu
;;

securetmpv ) date
none /tmp tmpfs nodev,nosuid,noexec 0 0
echo "tmp partition has been mounted to a temporary file for extra security."
sleep 4
showMenu
;;

allconfigserver ) date
mkdir configserver
cd configserver
wget http://www.configserver.com/free/cmq.tgz
tar -xzf cmq.tgz
cd cmq/
sh install.sh
cd ..
rm -Rf cmq.tgz
wget http://www.configserver.com/free/cmm.tgz
tar -xzf cmm.tgz
cd cmm/
sh install.sh
cd ..
rm -Rf cmm.tgz
wget http://www.configserver.com/free/cse.tgz
tar -xzf cse.tgz
cd cse
sh install.sh
cd ..
rm -Rf cse.tgz
wget http://www.configserver.com/free/cmc.tgz
tar -xzf cmc.tgz
cd cmc/
sh install.sh
cd ..
rm -Rf cmc.tgz
echo "All Plugins from ConfigServer.com (without CSF) has been successfully installed!"
echo "Plugins available via WHM plugin tab"
sleep 4
showMenu
;;

maldetect ) date
wget http://www.rfxn.com/downloads/maldetect-current.tar.gz
tar -xzvf maldetect-current.tar.gz
cd maldetect-*
sh install.sh
cd ..
rm -Rf maldetect-current.tar.gz
echo "Linux Malware Detect has been installed!"
sleep 4
showMenu
;;

chkrootkit ) date
cd /usr/src
wget http://underhostbackup.com/update/chkrootkit.tar.gz
tar -xvzf chkrootkit.tar.gz
cd chkrootkit-*/
make sense
./chkrootkit
cd ..
echo "CHRootKit has been installed!"
sleep 4
showMenu
;;

logview ) date
wget http://www.logview.org/logview-install
chmod +x logview-install
./logview-install
rm -f logview-install
cd ..
echo "logview plugins successfully installed!"
echo "Plugins available via WHM plugin tab"
sleep 4
showMenu
;;

firewall ) date
wget http://www.configserver.com/free/csf.tgz
tar -xzf csf.tgz
cd csf
sh install.sh
cd ..
rm -Rf csf.tgz
echo "CSF successfully installed!"
sleep 4
showMenu
;;

htopsetup ) date
wget http://underhostbackup.com/update/htop-0.8.3.tar.gz
tar -xvf htop-0.8.3.tar.gz
cd htop-0.8.3
yum install gcc c++
yum install ncurses-devel
./configure
make
make install
echo "htop successfully installed!"
echo "type htop to start"
sleep 4
showMenu
;;

bfdetect ) date
cd /root/
wget http://www.rfxnetworks.com/downloads/bfd-current.tar.gz
tar -xvzf bfd-current.tar.gz
cd bfd-1.4
./install.sh
echo -e "Please enter your email:"
read email
echo "You entered: $email"
echo "ALERT_USR="1"" >>  /usr/local/bfd/conf.bfd
echo "EMAIL_USR="$email"" >>  /usr/local/bfd/conf.bfd
echo "Brute Force Detection has been installed!"
echo "Email would be sent to $email"
/usr/local/sbin/bfd -s
sleep 4
showMenu
;;

port ) echo -e "Please enter a new SSH port: "
read sshport
echo "You entered: $sshport"
echo "Port $sshport" >>  /etc/ssh/sshd_config
service sshd reload
echo "SSH port successfully changed!"
echo "Make sure to update your port in CSF and test before leaving your session!"
sleep 5
showMenu
;;

selinux ) sed -i 's/^SELINUX=/#SELINUX=/g' /etc/selinux/config
echo 'SELINUX=disabled' >> /etc/selinux/config
setenforce 0
echo "SELinux successfully disabled!"
sleep 4
showMenu
;;

update ) MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm
rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
rpm -K rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm
rpm -i rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm
else
wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el5.rf.i386.rpm
rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
rpm -K rpmforge-release-0.5.2-2.el5.rf.i386.rpm
rpm -i rpmforge-release-0.5.2-2.el5.rf.i386.rpm
fi
yum -y update
echo "System successfully updated!"
sleep 4
showMenu
;;

exit ) exit
showMenu
;;

*) echo "ERROR!";
echo "Press Enter to continue..." ; read ;;
esac
done
