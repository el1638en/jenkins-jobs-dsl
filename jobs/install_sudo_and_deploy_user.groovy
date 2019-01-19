import utilities.JobsUtils

// Job pour installer le programme sudo et ajouter l'utilisateur deploy (deploiement avec Ansible)
def job = freeStyleJob('INSTALL_SUDO_AND_DEPLOY_USER'){

    // Description du job.
    description('Ce job installe le programme sudo et ajoute l\'utilisateur deploy pour les deploiements Ansible.')


    // Définir les paramètres du Job
    parameters {
    stringParam('ADDRESS_IP', '', 'Adresse IP du serveur cible.')
    stringParam('PORT_NUMBER', '22', 'Port SSH du serveur.')
    stringParam('USERNAME', '', 'Nom de l\'utilisateur.')
    nonStoredPasswordParam('PASSWORD', 'Mot de passe de l\'utilisateur.')
    nonStoredPasswordParam('ROOT_PASSWORD', 'Mot de passe du super-utilisateur.')
    }

    steps {

        shell(readFileFromWorkspace('scripts/INIT_ENVIRONMENT/export_program_to_server.sh'))
        // Installation du serveur
        shell(readFileFromWorkspace('scripts/INIT_ENVIRONMENT/init_environment.py'))
    }
}

JobsUtils.defaultWrappersPolicy(job)
JobsUtils.defaultLogRotatorPolicy(job)
