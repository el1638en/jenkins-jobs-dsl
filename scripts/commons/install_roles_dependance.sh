#!/usr/bin/env bash
set +x
set -e

if [ -z "${PS1}" ]; then
    export PS1="[\\u@\\h:\\w] $"
fi

source ${VIRTUALENV_DIRECTORY}/bin/activate

cd $PROJECT_NAME

WORD_TO_REMOVE="http://"

NEXUS_URL=${NEXUS_REPO_URL//$WORD_TO_REMOVE/}

sed -i "s/nexus-repository/${NEXUS_URL}/g" requirements.yml

ansible-galaxy install -p roles -f -r requirements.yml
