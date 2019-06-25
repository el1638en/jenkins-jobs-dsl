#!/usr/bin/env bash
set +x
set -e

cd ${WORKSPACE}/${PROJECT_NAME}

echo -n "Initialisation du fichier Ansible password file dans le repertoire : "; pwd

echo "deploy" > vault_passwd
