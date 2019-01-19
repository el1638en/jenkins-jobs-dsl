import utilities.JobsUtils

// Job pour produire un snapshot ou une release d'un rôle Ansible
def job = freeStyleJob('SNAPSHOT_OR_RELEASE_ANSIBLE_ROLE'){

    // Description du job.
    description('Ce job crée un snapshot ou une release d\'un rôle Ansible et charge l\'archive  sur un repository Nexus.')

    // Définir les paramètres du Job
    parameters {
        stringParam('BRANCHE', 'master', 'Branche à utiliser pour effectuer le snapshot ou la release.')
        stringParam('ROLE_NAME', '', 'Nom du rôle.')
        stringParam('ROLE_VERSION', '', 'Version du rôle.')
        booleanParam('RELEASE', true, 'Cocher si vous souhaitez faire une release. Décocher si vous souhaitez faire un snapshot.')
        booleanParam('LATEST', false, 'Cocher si vous faites la release de la dernière version stable du rôle.')
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
        shell(readFileFromWorkspace('scripts/SNAPSHOT_OR_RELEASE_ANSIBLE_ROLE/snapshot_or_release_ansible_role.sh'))
    }
}

JobsUtils.defaultWrappersPolicy(job)
JobsUtils.defaultLogRotatorPolicy(job)
