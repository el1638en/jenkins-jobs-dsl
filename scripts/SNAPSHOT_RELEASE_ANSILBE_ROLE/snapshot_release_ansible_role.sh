#!/usr/bin/env bash

set +e
set -u

REPO_USERNAME="${NEXUS_REPO_USERNAME}"
REPO_PASSWORD="${NEXUS_REPO_PASSWORD}"
NEXUS_URL="${NEXUS_REPO_URL}"
REPO_ANSIBLE_GALAXY_BASE_URL="${NEXUS_URL}/repository/ansible-galaxy"

check_arguments() {
  if [ -z "${ROLE_NAME}" ]; then
    echo "Le nom du rôle est obligatoire."
    exit 1
  fi

  if [ -z "${ROLE_VERSION}" ]; then
    echo "La version du rôle est obligatoire."
    exit 1
  fi

  if [ -z "${RELEASE}" ]; then
    echo "Vous devez preciser s'il s'agit d'une release ou d'un snapshot."
    exit 1
  fi
}

build_archive_name() {
  if [[ ${RELEASE} == "false" ]]; then
    echo "${ROLE_NAME}-${ROLE_VERSION}-SNAPSHOT.tar.gz"
  else
    echo "${ROLE_NAME}-${ROLE_VERSION}.tar.gz"
  fi
}

build_repository_name() {
  if [[ ${RELEASE} == "false" ]]; then
    echo "snapshots"
  else
    echo "releases"
  fi
}

push_archive() {
  repository_name=$(build_repository_name)
  archive_name=$(build_archive_name)
  user=${REPO_USERNAME}
  password=${REPO_PASSWORD}
  repo_url="${REPO_ANSIBLE_GALAXY_BASE_URL}/${repository_name}/${ROLE_NAME}/${archive_name}"

  echo "Repository name: ${repository_name}"
  echo "Archive name: ${archive_name}"
  echo "Repository Url: ${repo_url}"

  tar -zcvf ${archive_name} ${ROLE_NAME} --exclude .git
  curl -sSf -k -u ${user}:${password} -T ${archive_name} ${repo_url}
}

check_arguments
push_archive
