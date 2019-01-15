pipeline {
  environment {
    registry = "vaniparidhyani/hello-apache"
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
