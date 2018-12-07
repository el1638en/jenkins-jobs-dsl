#!/usr/bin/env bash
set +x
set -e

if [ -z "${PS1}" ]; then
    export PS1="[\\u@\\h:\\w] $"
fi

source ${VIRTUALENV_DIRECTORY}/bin/activate

cd $PROJECT_NAME

ansible-galaxy install -p roles -f -r requirements.yml
