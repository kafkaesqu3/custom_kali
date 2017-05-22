#!/bin/bash

#mkdir -p /root/.ssh
# Replace "YOUR SSH KEY" with a your ssh public key.
#echo "YOUR SSH KEY" > /root/.ssh/authorized_keys
# Disable SSH password authentication
#sed 's/#PasswordAuthentication\ yes/PasswordAuthentication\ no/g' /etc/ssh/sshd_config

# Set the admin password of OpenVas to admin123
#sed '/add_user/ s|$| -w admin123|' /usr/bin/openvas-setup
#/usr/bin/openvas-setup
#rm -rf /etc/rc.local

#cat << EOF > /etc/rc.local
#!/bin/bash
#/etc/init.d/greenbone-security-assistant start
#/etc/init.d/openvas-scanner start
#/etc/init.d/openvas-administrator start
#/etc/init.d/openvas-manager start
# Set msfrpcd to username "metadmin" and password "metpass123" on port 1337
# /usr/bin/msfrpcd -S -U metadmin -P metpass123 -p 1337 &

#exit 0
#EOF

#chmod 755 /etc/rc.local

#update-rc.d ssh enable
#update-rc.d postgresql enable
#update-rc.d metasploit enable

#attempt to start services
systemctl start ssh
systemctl enable ssh

systemctl start postgresql
systemctl enable postgresql

# allow root to log in with password
sed -i '/PermitRootLogin/c\PermitRootLogin yes' /etc/ssh/sshd_config

# updates
apt-get update
DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade
DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

#kernel headers
#apt-get install linux-headers-`uname -a`

# Initialize msfdb
msfdb init



cat <<EOF >> /root/.bashrc
export EDITOR=vim
export PYTHONSTARTUP=~/.pythonrc

alias la='ls -a --color=auto'
alias ll='ls -l --color=auto'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias h='history'
alias j='jobs -l'
alias ports='netstat -tulnp'
alias listen='nc -nvlp'
alias processes='ps auwwx'

#for piping output to X clipboard. Obviously only works on systems with X
alias clipboard="xargs echo -n | xclip -selection clipboard"

PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$ '
EOF


# Grab git repos

# https://github.com/leebaird/discover
git clone https://github.com/leebaird/discover.git /opt/discover
# https://github.com/trustedsec/ptf
git clone https://github.com/trustedsec/ptf.git /opt/Pentester-Framework
# https://github.com/galkan/crowbar
git clone https://github.com/galkan/crowbar.git /opt/crowbar

#RECON
mkdir -p /opt/recon
# https://github.com/ChrisTruncer/EyeWitness
git clone https://github.com/ChrisTruncer/EyeWitness.git /opt/recon/EyeWitness
# setup Eyewitness
/opt/recon/EyeWitness/setup/setup.sh
# https://github.com/trustedsec/ridenum
git clone https://github.com/trustedsec/ridenum.git /opt/recon/ridenum
# https://github.com/DataSploit/datasploit
git clone https://github.com/DataSploit/datasploit.git /opt/recon/datasploit
# https://github.com/dxa4481/truffleHog
git clone https://github.com/dxa4481/truffleHog.git /opt/recon/truffleHog
# https://github.com/minisllc/domainhunter
git clone https://github.com/minisllc/domainhunter.git /opt/recon/domainhunter
# https://github.com/sensepost/ruler
git clone https://github.com/sensepost/ruler.git /opt/recon/ruler

#NETWORKING
mkdir -p /opt/networking/
# https://github.com/lgandx/PCredz
git clone https://github.com/lgandx/PCredz.git /opt/networking/PCredz
# https://github.com/CoreSecurity/impacket
git clone https://github.com/CoreSecurity/impacket.git /opt/networking/impacket
# https://github.com/rofl0r/proxychains-ng
git clone https://github.com/rofl0r/proxychains-ng.git /opt/networking/proxychains-ng

#PAYLOADS
mkdir -p /opt/payloads
# https://github.com/Veil-Framework/Veil
git clone https://github.com/Veil-Framework/Veil.git /opt/payloads/Veil
# https://github.com/Genetic-Malware/Ebowla
git clone https://github.com/Genetic-Malware/Ebowla.git /opt/payloads/Ebowla

#EXPLOITS
mkdir -o /opt/exploits
# https://github.com/nidem/kerberoast
git clone https://github.com/nidem/kerberoast.git /opt/exploits/kerberoast
# https://github.com/DanMcInerney/autorelay
git clone https://github.com/DanMcInerney/autorelay.git /opt/exploits/autorelay

#POST
mkdir -p /opt/post
# https://github.com/pentestgeek/smbexec
git clone https://github.com/pentestgeek/smbexec.git /opt/post/smbexec
# https://github.com/byt3bl33d3r/CrackMapExec
git clone https://github.com/byt3bl33d3r/CrackMapExec.git /opt/post/CrackMapExec
git clone https://github.com/byt3bl33d3r/CrackMapExec.git -b v3.1.5dev/opt/post/CrackMapExec-dev/
python /opt/post/CrackMapExec/setup.py install

# https://github.com/nccgroup/redsnarf
git clone https://github.com/nccgroup/redsnarf.git /opt/post/redsnarf
# set up redsnarf
pip install wget
git clone https://github.com/savon-noir/python-libnmap.git /opt/post/redsnarf/python-libnmap
cd /opt/post/redsnarf/python-libnmap
python setup.py install
cd /opt/post/redsnarf/
apt-get install libsasl2-dev python-dev libldap2-dev libssl-dev
pip install python-ldap
pip install pysmb

# https://github.com/funkandwagnalls/ranger
git clone https://github.com/funkandwagnalls/ranger.git /opt/post/ranger
# setup ranger
bash /opt/post/ranger/setup.sh

#POWERSHELL
mkdir -p /opt/powershell/
# https://github.com/PowerShellMafia/PowerSploit
git clone https://github.com/PowerShellMafia/PowerSploit.git /opt/powershell/PowerSploit
git clone https://github.com/PowerShellMafia/PowerSploit.git -b dev /opt/powershell/PowerSploit-dev
# https://github.com/EmpireProject/Empire
git clone https://github.com/EmpireProject/Empire.git /opt/powershell/Empire
git clone https://github.com/EmpireProject/Empire.git -b 2.0_beta /opt/powershell/Empire-dev
# https://github.com/samratashok/nishang
git clone https://github.com/samratashok/nishang.git /opt/powershell/nishang
# https://github.com/danielbohannon/Invoke-Obfuscation
git clone https://github.com/danielbohannon/Invoke-Obfuscation.git /opt/powershell/Invoke-Obfuscation
# https://github.com/trustedsec/unicorn
git clone https://github.com/trustedsec/unicorn.git /opt/powershell/unicorn
# https://github.com/Kevin-Robertson/Inveigh
git clone https://github.com/Kevin-Robertson/Inveigh.git /opt/powershell/Inveigh
# https://github.com/whitehat-zero/PowEnum
git clone https://github.com/whitehat-zero/PowEnum.git /opt/powershell/PowEnum
# https://github.com/rvrsh3ll/Misc-Powershell-Scripts
git clone https://github.com/rvrsh3ll/Misc-Powershell-Scripts.git /opt/powershell/Misc-Powershell-Scripts
# https://github.com/dafthack/MailSniper
git clone https://github.com/dafthack/MailSniper.git /opt/powershell/MailSniper
# https://github.com/rasta-mouse/Sherlock
git clone https://github.com/rasta-mouse/Sherlock.git /opt/powershell/Sherlock
# https://github.com/Kevin-Robertson/Invoke-TheHash
git clone https://github.com/Kevin-Robertson/Invoke-TheHash.git /opt/powershell/Invoke-TheHash
# https://github.com/BloodHoundAD/BloodHound
git clone https://github.com/BloodHoundAD/BloodHound.git /opt/powershell/BloodHound
# https://github.com/xorrior/EmailRaider
git clone https://github.com/xorrior/EmailRaider.git /opt/powershell/EmailRaider
# https://github.com/ChrisTruncer/WMImplant
git clone https://github.com/ChrisTruncer/WMImplant.git /opt/payloads/WMImplant


#WINDOWS
mkdir -p /opt/exe/
# https://github.com/maaaaz/CrackMapExecWin
git clone https://github.com/maaaaz/CrackMapExecWin.git /opt/exe/CrackMapExecWin
# https://github.com/mubix/post-exploitation
git clone https://github.com/mubix/post-exploitation.git /opt/exe/post-exploitation
# https://github.com/lgandx/Responder-Windows
git clone https://github.com/lgandx/Responder-Windows.git /opt/exe/Responder-Windows
wget https://xxx.xxx.xxx.xxx/tools/Sysinternals.zip --no-check-certificate -O /opt/exe/
wget https://xxx.xxx.xxx.xxx/tools/nirsoft.zip --no-check-certificate -O /opt/exe/
wget https://xxx.xxx.xxx.xxx/tools/plink.exe --no-check-certificate -O /opt/exe/
wget https://xxx.xxx.xxx.xxx/tools/NetSess.exe --no-check-certificate -O /opt/exe/
wget https://xxx.xxx.xxx.xxx/tools/nc.exe --no-check-certificate -O /opt/exe/
wget https://xxx.xxx.xxx.xxx/tools/wce64.exe --no-check-certificate -O /opt/exe/
wget https://xxx.xxx.xxx.xxx/tools/wce.exe --no-check-certificate -O /opt/exe/
wget https://xxx.xxx.xxx.xxx/tools/vncviewer.exe --no-check-certificate -O /opt/exe/
wget https://xxx.xxx.xxx.xxx/tools/user2sid.exe --no-check-certificate -O /opt/exe/
wget https://xxx.xxx.xxx.xxx/tools/sid2user.exe --no-check-certificate -O /opt/exe/
wget https://xxx.xxx.xxx.xxx/tools/putty.exe --no-check-certificate -O /opt/exe/
wget https://xxx.xxx.xxx.xxx/tools/miadmin.exe --no-check-certificate -O /opt/exe/
wget https://xxx.xxx.xxx.xxx/tools/wget.exe --no-check-certificate -O /opt/exe/
wget https://xxx.xxx.xxx.xxx/tools/ShareEnum.exe --no-check-certificate -O /opt/exe/
wget https://xxx.xxx.xxx.xxx/tools/enum.vbs --no-check-certificate -O /opt/exe/
wget https://xxx.xxx.xxx.xxx/tools/sqlexecany.vbs --no-check-certificate -O /opt/exe/
wget https://xxx.xxx.xxx.xxx/tools/sqlexec.vbs --no-check-certificate -O /opt/exe/
wget https://xxx.xxx.xxx.xxx/tools/wget.vbs --no-check-certificate -O /opt/exe/

