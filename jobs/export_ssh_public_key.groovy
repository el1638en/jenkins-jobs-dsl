import utilities.JobsUtils

// Job pour exporter une clé publique SSH vers un compte utilisateur.
def job = freeStyleJob('EXPORT_SSH_PUBLIC_KEY'){

    // Description du job.
    description('Ce job exporte une clé publique SSH vers un compte utilisateur.')

    // Définir les paramètres du Job
    parameters {
        stringParam('ADDRESS_IP_DNS', '', 'Adresse IP ou DNS du serveur cible.')
        stringParam('PORT_NUMBER', '22', 'Port SSH du serveur.')
        stringParam('USERNAME', '', 'Nom de l\'utilisateur')
        nonStoredPasswordParam('PASSWORD', 'Mot de passe de l\'utilisateur.')
        stringParam('SSH_PUBLIC_KEY', '', 'Copier ici votre clé publique SSH.')
    }

    steps {
        // Installation du serveur
        shell(readFileFromWorkspace('scripts/EXPORT_SSH_PUBLIC_KEY/export_ssh_public_key.sh'))
    }
}

JobsUtils.defaultWrappersPolicy(job)
JobsUtils.defaultLogRotatorPolicy(job)
