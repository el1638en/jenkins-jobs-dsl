import utilities.JobsUtils

// Job pour installer les configurations de base d'un serveur
def job = freeStyleJob('INSTALL_SERVER'){

    // Description du job.
    description('Ce job installe et configure les packages de base sur un nouveau serveur.')

    // Injecter les variables d'environnement
    environmentVariables {
      env('VIRTUALENV_NAME', 'VIRTUALENV')
      env('VIRTUALENV_DIRECTORY', '${WORKSPACE}/${VIRTUALENV_NAME}')
      env('PROJECT_NAME', 'install_server')
    }

    // Définir les paramètres du Job
    parameters {
        stringParam('commentaire', '', 'Commentaire pour décrire le déploiement')
        stringParam('BRANCHE', 'master', 'Branche à utiliser (TODO - à virer).')
        stringParam('MACHINE_NAME', '', 'Nom du serveur cible.')
        stringParam('ADDRESS_IP', '', 'Adresse IP du serveur cible.')
        booleanParam('debug', true, 'Afficher les traces détaillées du déploiement.')
        booleanParam('installComplete', false, 'Procéder à une installation complète.')
        booleanParam('clean_services', false, 'Supprimer les packages de base inutiles.')
        booleanParam('tools', false, 'Installation des outils de base tels que git, openssl, etc.')
        booleanParam('firewall', false, 'Installation d\'un par-feu.')
        booleanParam('ssh', false, 'Installer/Configurer le serveur SSH.')
        booleanParam('fail2ban', false, 'Installer fail2ban (Sécurité).')
        booleanParam('portsentry', false, 'Installer portsentry (Sécurité).')
        booleanParam('ntp', false, 'Installer ntp.')
        booleanParam('admin_tools', false, ' Installer les outils d\'admin personnalisés.')
        booleanParam('docker', false, 'Installer Docker.')
        booleanParam('monit', false, 'Installer monit pour surveiller le serveur.')
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
        // Téléchargement des rôles de dépendance
        shell(readFileFromWorkspace('scripts/commons/install_roles_dependance.sh'))
        // Charger la clé privée du user avec ssh-agent
        shell(readFileFromWorkspace('scripts/commons/launch_ssh_agent.sh'))
        // Initialisation du fichier Ansible password file TODO
        // shell(readFileFromWorkspace('scripts/commons/init_ansible_vault_file.sh'))
        // Installation du serveur
        shell(readFileFromWorkspace('scripts/INSTALL_SERVER/install_server.sh'))
    }
}

JobsUtils.defaultWrappersPolicy(job)
JobsUtils.defaultLogRotatorPolicy(job)
