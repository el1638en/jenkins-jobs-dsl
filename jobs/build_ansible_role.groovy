import utilities.JobsUtils

// Job pour produire un snapshot ou une release d'un rôle Ansible
def job = freeStyleJob('BUILD_ANSILBE_ROLE'){

    // Description du job.
    description('Ce job exécute un rôle Ansible.')

    // Injecter les variables d'environnement
    environmentVariables {
      env('VIRTUALENV_NAME', 'VIRTUALENV')
      env('VIRTUALENV_DIRECTORY', '${WORKSPACE}/${VIRTUALENV_NAME}')
    }

    // Définir les paramètres du Job
    parameters {
        stringParam('BRANCHE', 'master', 'Branche à utiliser pour effectuer le build.')
        stringParam('ROLE_NAME', '', 'Nom du rôle.')
    }

    // Récupérer sur Git la branche à utiliser pour faire le deploiement
    scm {
        git {
            remote {
                url('https://github.com/el1638en/ansible-galaxy.git')
            }
            branch('${BRANCHE}')
            extensions{
                localBranch('${BRANCHE}')
            }
        }
    }

    steps {
        // Création d'un environnement virtuel pour exécuter le rôle
        shell(readFileFromWorkspace('scripts/commons/create_virtualenv.sh'))
        // Exécution du rôle
        shell(readFileFromWorkspace('scripts/BUILD_ANSILBE_ROLE/build_ansible_role.sh'))
    }
}

JobsUtils.defaultWrappersPolicy(job)
JobsUtils.defaultLogRotatorPolicy(job)
