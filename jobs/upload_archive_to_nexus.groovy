import utilities.JobsUtils

// Job d'upload de fichiers sur le serveur Nexus
def job = freeStyleJob('UPLOAD_ARCHIVE_TO_NEXUS'){
  // Description du job.
  description('Ce job permet d\'uploader des fichiers sur Nexus')

  // Définir les paramètres du Job
  parameters {
  stringParam('REPOSITORY_ID', '', 'Repository sur lequel le fichier sera déposé.')
  fileParam('ARCHIVE_FILE', 'L\'archive à déposer sur le serveur Nexus.')
  }

  steps {
  shell(readFileFromWorkspace('scripts/UPLOAD_ARCHIVE_TO_NEXUS/upload_archive_to_nexus.sh'))
  }
}

JobsUtils.defaultWrappersPolicy(job)
JobsUtils.defaultLogRotatorPolicy(job)
