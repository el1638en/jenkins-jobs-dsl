import utilities.JobsUtils

// Job pour installer les configurations de base d'un serveur
def job = freeStyleJob('INSTALL_SERVER_FROM_SCRATCH'){

    // Description du job.
    description('Ce job installe les configurations de base d\'un serveur.')

    // Injecter les variables d'environnement
    environmentVariables {
      env('VIRTUALENV_NAME', 'VIRTUALENV')
      env('VIRTUALENV_DIRECTORY', '${WORKSPACE}/${VIRTUALENV_NAME}')
      env('PROJECT_NAME', 'install_server_from_scratch')
    }

    // Définir les paramètres du Job
    parameters {
        stringParam('BRANCHE', 'master', 'Branche à utiliser pour effectuer le snapshot ou la release.')
        stringParam('MACHINE_NAME', '', 'Nom du serveur cible.')
        stringParam('ADDRESS_IP', '', 'Adresse IP de la machine.')
    }

    // Récupérer sur Git la branche à utiliser pour faire le deploiement
    scm {
        git {
            remote {
                url('https://github.com/el1638en/projects_box.git')
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
        // Installation des rôles de dépendance
        shell(readFileFromWorkspace('scripts/commons/install_roles_dependance.sh'))
    }
}

JobsUtils.defaultWrappersPolicy(job)
JobsUtils.defaultLogRotatorPolicy(job)
