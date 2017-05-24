#!/bin/bash

printf "Setup our build environment\n"
apt-get install live-build -y
if [ -d "live-build-config" ]; then
	printf "you appear to already have your build environment downloaded...\n"
else
git clone git://git.kali.org/live-build-config.git
fi

cd live-build-config

printf "adding packages not included in kali\n"
mkdir -p kali-config/common/package-lists/
echo "realpath" > kali-config/common/package-lists/kali.list.chroot
echo "tree" >> kali-config/common/package-lists/kali.list.chroot
echo "python-pip" >> kali-config/common/package-lists/kali.list.chroot
echo "libssl-dev" >> kali-config/common/package-lists/kali.list.chroot
echo "libffi-dev" >> kali-config/common/package-lists/kali.list.chroot
echo "python-dev" >> kali-config/common/package-lists/kali.list.chroot
echo "build-essential" >> kali-config/common/package-lists/kali.list.chroot
echo "coreutils" >> kali-config/common/package-lists/kali.list.chroot
echo "vim-gtk" >> kali-config/common/package-lists/kali.list.chroot
echo "vim-gnome" >> kali-config/common/package-lists/kali.list.chroot
echo "xclip" >> kali-config/common/package-lists/kali.list.chroot
echo "open-vm-tools" >> kali-config/common/package-lists/kali.list.chroot
echo "open-vm-tools-desktop" >> kali-config/common/package-lists/kali.list.chroot
echo "open-vm-tools-dev" >> kali-config/common/package-lists/kali.list.chroot
echo "open-vm-tools-dkms" >> kali-config/common/package-lists/kali.list.chroot
echo "fuse" >> kali-config/common/package-lists/kali.list.chroot
# ADD YOUR PACKAGES HERE

printf "copying .deb files to packages folder (automatically installed)\n"
mkdir -p kali-config/common/packages.chroot
cp ../packages/nessus*.deb kali-config/common/packages.chroot/
cp ../packages/nomachine*.deb kali-config/common/packages.chroot/

# CHROOT OVERLAY
# kali-config/common/includes.chroot/
# files you want to overlay on the filesystem during your build go here
if [ -f /root/.ssh/authorized_keys ]; then
	printf "Adding public key from /root/.ssh/authorized_keys\n"
	mkdir -p kali-config/common/includes.chroot/root/.ssh/
	cp /root/.ssh/authorized_keys kali-config/common/includes.chroot/root/.ssh/authorized_keys
else
	printf "WARNING no public key detected in /root/.ssh/authorized_keys\n"
fi

if [ -f ../packages/VMware*.bundle ]; then
	printf "Adding VMware player to /root (manual install required)\n"
	cp ../packages/VMware*.bundle kali-config/common/includes.chroot/root/
else
	printf "WARNING no VMware Player binary in packages folder\n"
fi

if [ -f ../packages/burpsuite*.jar ]; then
	printf "Adding Burp to /root (manual install required)\n"
	cp ../packages/burpsuite*.jar kali-config/common/includes.chroot/root/
else
	printf "WARNING no burp.jar in packages folder\n"
fi

if [ -f ../packages/IE11.Win7.For.Windows.VMware/IE11_-_Win7-disk1.vmdk ]; then
	printf "Adding Windows VM image in /root\n"
	cp -r ../packages/IE11.Win7.For.Windows.VMware kali-config/common/includes.chroot/root/
else
	printf "WARNING no windows VM found in packages folder\n"
fi

#configs
printf "Modifying default vim, screen, and python configs\n"
cp ../packages/vimrc kali-config/common/includes.chroot/root/.vimrc
cp ../packages/pythonrc kali-config/common/includes.chroot/root/.pythonrc
cp ../packages/screenrc kali-config/common/includes.chroot/root/.screenrc

# CHROOT BOOT HOOKS
# kali-config/common/hooks/
# these scripts run every time the server boots

printf "Adding chroot boot hooks\n"
mkdir -p kali-config/common/hooks/

# enable SSH server
echo "service ssh start" > kali-config/common/hooks/01-enable-ssh.chroot
echo "systemctl enable ssh" >> kali-config/common/hooks/01-enable-ssh.chroot
chmod +x kali-config/common/hooks/01-enable-ssh.chroot

# enable postgresql server for metasploit
echo "service ssh start" > kali-config/common/hooks/02-enable-postgres.chroot
echo "systemctl enable postgresql" >> kali-config/common/hooks/02-enable-postgres.chroot
chmod +x kali-config/common/hooks/02-enable-postgres.chroot

# Update Metasploit
echo "msfupdate" > kali-config/common/hooks/03-update-msf.chroot
chmod +x kali-config/common/hooks/03-update-msf.chroot

# Update wpscan
echo "wpscan --update" > kali-config/common/hooks/04-update-wpscan.chroot
chmod +x kali-config/common/hooks/04-update-wpscan.chroot

#update nikto
echo "nikto -update" > kali-config/common/hooks/05-update-nikto.chroot
chmod +x kali-config/common/hooks/05-update-nikto.chroot

# preseed file for unattended install 
printf "Fetching preseed file for unattended install\n"
mkdir -p kali-config/common/includes.installer
cp ../preseed.cfg kali-config/common/includes.installer/preseed.cfg 

printf "adding boot menu options that will process preseed file\n"
# ref http://www.syslinux.org/wiki/index.php?title=Config
cat << EOF > kali-config/common/includes.binary/isolinux/install.cfg
label install
menu label ^Install Custom (Automated)
linux /install/vmlinuz
initrd /install/initrd.gz
append vga=788 -- quiet file=/cdrom/install/preseed.cfg locale=en_US keymap=us hostname=kali domain=local.lan
EOF

cat << EOF > kali-config/common/includes.binary/isolinux/isolinux.cfg
include menu.cfg
ui vesamenu.c32
default install
prompt 0
timeout 70
EOF

printf "Ready for build? y/n\n"
read input
if [[ $input == 'y' ]]; then
	./build.sh --variant gnome --distribution kali-rolling --verbose
else
	printf "Not building at this time\n"
	printf "Execute the following command when you're ready to build: \n"
	printf "./build.sh --variant gnome --distribution kali-rolling --verbose\n"
fi
