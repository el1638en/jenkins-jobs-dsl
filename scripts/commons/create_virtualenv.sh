#!/usr/bin/env bash

set +x
set -e

if [ -z "${PS1}" ]; then
    export PS1="[\\u@\\h:\\w] $"
fi

echo "############  [INFO] Création de l'environnement virtuel ${VIRTUALENV_NAME} pour le job ${JOB_NAME}  ###########"

# Création de virtualenv s'il n'existe pas encore
if [ ! -e "${VIRTUALENV_DIRECTORY}/bin/activate" ]; then
  virtualenv ${VIRTUALENV_DIRECTORY}
fi

# Activation de l'environnement virtuel
source ${VIRTUALENV_DIRECTORY}/bin/activate

echo "############  [INFO] Fin de l'installation de l'environnement virtuel ${VIRTUALENV_NAME} installé et activé. ###########"

echo "############  [INFO] Installation des packages Molecule & Docker dans l'environnement virtuel :${VIRTUALENV_NAME}  ###########"

pip install molecule docker

echo "############  [INFO] Fin de l'installation des packages Molecule & Docker dans l'environnement virtuel : ${VIRTUALENV_NAME}.  ##########"
