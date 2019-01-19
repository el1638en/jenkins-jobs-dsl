#!/bin/bash
### BEGIN INIT INFO
# Description:
# Ce script shell :
# - exporte le programme d'initialisation d'un serveur
# - clôture la connexion SSH.
### END INIT INFO

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

smallLoader() {
    echo ""
    echo ""
    echo -ne '[ + + +             ] 3s \r'
    sleep 1
    echo -ne '[ + + + + + +       ] 2s \r'
    sleep 1
    echo -ne '[ + + + + + + + + + ] 1s \r'
    sleep 1
    echo -ne '[ + + + + + + + + + ]... \r'
    echo -ne '\n'
}

smallLoader
echo ""
echo -e "${CYELLOW} Export du fichier du programme par SSH sur le serveur $ADDRESS_IP"
echo ""
echo -e "${CCYAN}-----------------------------------------------------------------------${CEND}"
echo ""
echo -e "Serveur distant : ${CGREEN}${ADDRESS_IP}${CEND}"
echo -e "Utilisateur : ${CGREEN}${USERNAME}${CEND}"
echo -e "Mot de passe : ${CGREEN}**********${CEND}"
echo -e "Port SSH : ${CGREEN}${PORT_NUMBER}${CEND}"
echo ""
echo -e "${CCYAN}-----------------------------------------------------------------------${CEND}"
echo ""
echo ""
echo -e "${CCYAN}-----------------------------------------------------------------------${CEND}"
echo ""
echo -e "${CCYAN}-----------------------------------------------------------------------${CEND}"
echo ""
$SSH_PASS -p $PASSWORD scp -P $PORT_NUMBER /var/lib/jenkins/custom_scripts/install_sudo_and_user_deploy_environment.sh $USERNAME@$ADDRESS_IP:~/
