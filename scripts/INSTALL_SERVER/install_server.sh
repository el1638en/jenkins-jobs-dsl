#!/usr/bin/env bash
set +x
set -e

if [ -z "${PS1}" ]; then
    export PS1="[\\u@\\h:\\w] $"
fi

export ANSIBLE_FORCE_COLOR="true"
export ANSIBLE_HOST_KEY_CHECKING="False"
export ANSIBLE_KEEP_REMOTE_FILES=1

echo "####################################"
echo $commentaire
echo "####################################"

echo "Activation de l'environnement virtualenv"
source ${VIRTUALENV_DIRECTORY}/bin/activate
echo -n "Repertoire courant : "; pwd

cd ${WORKSPACE}/${PROJECT_NAME}

# Initialisation de l'inventory/hosts
INVENTORY_FILE="inventory/hosts.yml"
echo "$MACHINE_NAME ansible_host=$ADDRESS_IP ansible_connection=ssh ansible_become_pass=" > $INVENTORY_FILE
echo "[all]" >> $INVENTORY_FILE
echo "$MACHINE_NAME" >> $INVENTORY_FILE

debug_opt=""
limit=""
tags="-t always"

if [ "${debug}" == "true" ]; then
 debug_opt="-vvvv"
fi

if [ "${clean_services}" == "true" ]; then
     tags="${tags},clean_services"
fi

if [ "${tools}" == "true" ]; then
     tags="${tags},tools"
fi

if [ "${firewall}" == "true" ]; then
     tags="${tags},firewall"
fi

if [ "${ssh}" == "true" ]; then
     tags="${tags},ssh"
fi

if [ "${fail2ban}" == "true" ]; then
     tags="${tags},fail2ban"
fi

if [ "${portsentry}" == "true" ]; then
     tags="${tags},portsentry"
fi

if [ "${ntp}" == "true" ]; then
     tags="${tags},ntp"
fi

if [ "${admin_tools}" == "true" ]; then
     tags="${tags},admin_tools"
fi

if [ "${docker}" == "true" ]; then
     tags="${tags},docker"
fi

if [ "${monit}" == "true" ]; then
     tags="${tags},monit"
fi

if [ "${installComplete}" == "true" ]; then
  tags=""
fi


echo "==== Ansible Version ======"
ansible-playbook --version
echo "==========================="
ansible-playbook -i $INVENTORY_FILE playbook.yml ${debug_opt} ${tags}
