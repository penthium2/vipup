#!/bin/bash
# ALPHA VERSION OF vipup Version 5
# How to upgrade your viperr 8 to viperr 9 :
#
#Update your system :
#dnf update
#
#Install dnf-plugin-system-upgrade  :
#dnf install dnf-plugin-system-upgrade
#
#Upgrade
#dnf system-upgrade download --releasever=24
#After it , 
#
#dnf system-upgrade reboot
#and wait, wait, wait....
spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}
# Method to kill the animation :
killspinner() {
kill $pidspin 
printf "\n"
}


echo " Before using this script please do that : 
#Update your system :
dnf update
#Install dnf-plugin-system-upgrade  :
dnf install dnf-plugin-system-upgrade
#Upgrade
dnf system-upgrade download --releasever=24
#After it ,
dnf system-upgrade reboot
#and wait, wait, wait.... "
read -p "Are You ready to upgrade ? type yes in UPPER CASE : " yes
if [[ "$yes" = YES ]]
then

rm -r /etc/yum.repos.d/viperr*
dnf clean all
dnf -y install http://coyotus.com/viperr/repo/Viperr/9/base/viperr-repo-24-2.viperr.fc24.noarch.rpm
dnf -y distro-sync

package-cleanup --cleandupes
package-cleanup --orphans > ~/orphans_rpms
package-cleanup --problems
dnf -y install lxrandr

sed -i 's/Fedora release 24 (Twenty Four)/Viperr release 09 (Vipera Dagon)/g' /etc/fedora-release
sed -i 's/Viperr release 08 (Vipera Azathoth) /Viperr release 09 (Vipera Dagon) /g' /etc/issue /etc/issue.net

echo 'NAME=Viperr
VERSION="09 (Vipera Dagon)"
ID=viperr
VERSION_ID=09
PRETTY_NAME="Viperr 09 (Vipera Dagon)"
ANSI_COLOR="0;34"
CPE_NAME="cpe:/o:viperr:viperr:09"
HOME_URL="https://viperr.org/"
BUG_REPORT_URL="https://bugzilla.redhat.com/"
REDHAT_BUGZILLA_PRODUCT="Fedora"
REDHAT_BUGZILLA_PRODUCT_VERSION=24
REDHAT_SUPPORT_PRODUCT="Fedora"
REDHAT_SUPPORT_PRODUCT_VERSION=24
PRIVACY_POLICY_URL=https://fedoraproject.org/wiki/Legal:PrivacyPolicy' > /etc/os-release
printf "configuring plymouth, please wait.."
spinner &
pidspin=$(jobs -p)
disown 
plymouth-set-default-theme viperr
/usr/libexec/plymouth/plymouth-update-initrd
killspinner
echo " Your migration is over.
Verify the file ~/orphans_rpms and analyse it
If you want to have all new stuff : 2 solutions :
1) recomended :  create a new user
2) own your risk : copy all files from /etc/skel/* to your home directory
Have fun
"
echo "Please Add this line in your ~/.config/openbox/autostart to activate corectly polkit
/usr/bin/lxpolkit &
"
echo "Please launch this commande to activate new screen panel :
sed -i 's/arandr/lxrandr/' ~/.config/openbox/menu.xmli
"
echo "Please Add this line in your ~/.config/openbox/autostart to activate corectly vp-screen
vp-screen -d &"
else
echo see you soon
fi
