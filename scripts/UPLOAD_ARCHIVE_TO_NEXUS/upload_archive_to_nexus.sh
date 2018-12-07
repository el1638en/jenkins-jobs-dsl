#!/usr/bin/env bash

set +x
set -u

REPO_USERNAME="${NEXUS_REPO_USERNAME}"
REPO_PASSWORD="${NEXUS_REPO_PASSWORD}"
NEXUS_URL="${NEXUS_REPO_URL}"
REPO_URL="${NEXUS_URL}/repository/${REPOSITORY_ID}"


echo "####################################"
echo "======== Upload du fichier ======="
echo "####################################"

mv ARCHIVE_FILE ${ARCHIVE_FILE}

echo "URL Repositiory cible : $REPO_URL"
echo "nom de l'archive à déposer : ${ARCHIVE_FILE}"
curl -v -u ${REPO_USERNAME}:${REPO_PASSWORD} --upload-file ${ARCHIVE_FILE} ${repo_url}/${ARCHIVE_FILE}
echo "===== Fin du dépôt du fichier ===="
