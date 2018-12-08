#!/bin/bash
### BEGIN INIT INFO
# Description: Ce script shell installe le package sudo. Pour le lancer, il faut être l'utilisateur root.
### END INIT INFO

set -e

CSI="\033["
CEND="${CSI}0m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"
CPURPLE="${CSI}1;35m"
CCYAN="${CSI}1;36m"
CBROWN="${CSI}0;33m"
SSH_PASS="/usr/bin/sshpass"

USER_NAME=$1

# Ce programme permet d'installer le package sudo
install_sudo(){
	apt install -y sudo
}

# Ce programme attribue les droits de super-utilisateur "root" à un utilisateur
add_user_to_sudo(){
	USER=$USER_NAME
	user_groups=$(groups $USER)
	if [ -z "${user_groups##*"sudo"*}" ] ;then
    	echo "$USER has already sudo right.";
    else
    	adduser $USER sudo
    fi
}

# Ce programme ajoute l'utilisateur "deploy" pour les déploiements via Ansible.
add_ansible_user(){
	ANSIBLE_USER_NAME="deploy"
	ANSIBLE_USER_PASSWORD="deploy"
	getent passwd $ANSIBLE_USER_NAME > /dev/null 2&>1
	if [ `id -u $ANSIBLE_USER_NAME 2>/dev/null || echo -1` -ge 0 ]; then
		echo "User $ANSIBLE_USER_NAME already exist."
	else
    echo -e "${GREEN}Initializing Ansible user $ANSIBLE_USER_NAME account.${NO_COLOR}"
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $ANSIBLE_USER_PASSWORD)
		useradd -p $pass -d /home/"$ANSIBLE_USER_NAME" -m -s /bin/bash "$ANSIBLE_USER_NAME"
		echo -e "${GREEN}Ansible user $ANSIBLE_USER_NAME has been added to system successfully !${NO_COLOR}"
		USER_SSH_DIR="/home/$ANSIBLE_USER_NAME/.ssh"
		USER_AUTHORIZED_KEYS_FILE="$USER_SSH_DIR/authorized_keys"
		sudo -u $ANSIBLE_USER_NAME mkdir $USER_SSH_DIR
		sudo -u $ANSIBLE_USER_NAME chmod -R 700 $USER_SSH_DIR
		sudo -u $ANSIBLE_USER_NAME touch $USER_AUTHORIZED_KEYS_FILE
		sudo -u $ANSIBLE_USER_NAME chmod 600 $USER_AUTHORIZED_KEYS_FILE
		echo -e "${GREEN}Inialize ssh authorized_keys file for Ansible user $ANSIBLE_USER_NAME.${NO_COLOR}"
		echo "deploy	ALL=(ALL:ALL)	NOPASSWD:  ALL" > /etc/sudoers.d/$ANSIBLE_USER_NAME
		visudo -cf /etc/sudoers.d/$ANSIBLE_USER_NAME
		echo -e "${GREEN}Add user $ANSIBLE_USER_NAME to sudo group successfully.${NO_COLOR}"
	fi
}

smallLoader() {
    echo ""
    echo ""
    echo -ne '[ + + +             ] 3s \r'
    sleep 1
    echo -ne '[ + + + + + +       ] 2s \r'
    sleep 1
    echo -ne '[ + + + + + + + + + ] 1s \r'
    sleep 1
    echo -ne '[ + + + + + + + + + ] ... \r'
    echo -ne '\n'
}

# ##########################################################################
DOMAIN=$(hostname -d 2> /dev/null)   # domain.tld
HOSTNAME=$(hostname -s 2> /dev/null) # hostname
FQDN=$(hostname -f 2> /dev/null)     # hostname.domain.tld
HOSTNAMECTL=$(hostnamectl)   		 # hostnamectl

echo ""
echo -e "${CYELLOW} Installation automatique du serveur ${CEND}"
echo -e "${CCYAN}-----------------------------------------------------------------------${CEND}"
echo -e "${CCYAN}[ Votre serveur est actuellement configuré avec les valeurs suivantes ]${CEND}"
echo ""
echo -e "DOMAINE    : ${CGREEN}${DOMAIN}${CEND}"
echo -e "NOM D'HOTE : ${CGREEN}${HOSTNAME}${CEND}"
echo -e "FQDN       : ${CGREEN}${FQDN}${CEND}"
echo -e "Informations complètes     : \n${CGREEN}${HOSTNAMECTL}${CEND}"
echo ""
echo -e "${CCYAN}-----------------------------------------------------------------------${CEND}"
echo ""
smallLoader

# ##########################################################################
echo ""
echo -e "${CCYAN}-----------------------------${CEND}"
echo -e "${CCYAN}[ Installation du programme Sudo ]${CEND}"
echo -e "${CCYAN}-----------------------------${CEND}"
echo ""
install_sudo
smallLoader


# ##########################################################################
# echo ""
# echo -e "${CCYAN}-----------------------------${CEND}"
# echo -e "${CCYAN}[ Ajout des droits sudo à l'utilisateur $USER_NAME ]${CEND}"
# echo -e "${CCYAN}-----------------------------${CEND}"
# echo ""
# add_user_to_sudo $USER_NAME
# smallLoader

# ##########################################################################
echo ""
echo -e "${CCYAN}-----------------------------${CEND}"
echo -e "${CCYAN}[ Ajout de l'utilisateur deploy pour les déploiements Ansible ]${CEND}"
echo -e "${CCYAN}-----------------------------${CEND}"
echo ""
add_ansible_user
smallLoader
exit 0
