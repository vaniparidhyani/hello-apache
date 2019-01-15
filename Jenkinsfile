pipeline {
  environment {
    registry = "vaniparidhyani/firstrepo"
    registryCredential = 'docker-hub-credentials'
  }
  agent any
  stages {
    stage('Building image') {
      steps{
        script {
          docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
  }
}
