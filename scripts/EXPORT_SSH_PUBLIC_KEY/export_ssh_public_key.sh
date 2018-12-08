#!/usr/bin/env bash
set +x
set -e

### BEGIN INIT INFO
# Description: Ce script permet d'exporter une clé publique SSH vers le compte utilisateur sur un serveur distant.
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

echo ""
echo -e "${CYELLOW} Export de clé publique SSH"
echo ""
echo -e "${CCYAN}-----------------------------------------------------------------------${CEND}"
echo ""
echo -e "Serveur distant    : ${CGREEN}${ADDRESS_IP}${CEND}"
echo -e "Port SSH     		: ${CGREEN}${PORT_NUMBER}${CEND}"
echo -e "Utilisateur 		: ${CGREEN}${USERNAME}${CEND}"
echo -e "Mot de passe       : ${CGREEN}**********${CEND}"
echo ""
echo -e "${CCYAN}-----------------------------------------------------------------------${CEND}"
echo ""
smallLoader
echo $SSH_PUBLIC_KEY > PUBLIC_KEY_FILE.pub

$SSH_PASS -p $PASSWORD ssh-copy-id -p $PORT_NUMBER -o StrictHostKeyChecking=no -f -i PUBLIC_KEY_FILE.pub $USERNAME@$ADDRESS_IP

if [ $? -eq 0 ]; then
	echo -e "${CCYAN}-----------------------------------------------------------------------${CEND}"
	echo ""
	echo -e "${CYELLOW} Export réussi !"
	echo ""
	echo -e "${CCYAN}-----------------------------------------------------------------------${CEND}"
	echo ""
fi

rm -f PUBLIC_KEY_FILE.pub
