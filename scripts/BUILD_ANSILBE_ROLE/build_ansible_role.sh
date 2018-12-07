#!/usr/bin/env bash

set +x
set -e

if [ -z "${PS1}" ]; then
    export PS1="[\\u@\\h:\\w] $"
fi

source ${VIRTUALENV_DIRECTORY}/bin/activate

echo "###########   [INFO] Build du rôle Ansible ${ROLE_NAME}    ###########"

cd ${ROLE_NAME}

molecule test

deactivate

echo "###########  [INFO] Fin du build du rôle Ansible ${ROLE_NAME}    ###########"
