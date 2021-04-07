pipeline {
  
  agent {
      node {
          label 'Standard-Builder'
      }
  }

  options {
      buildDiscarder logRotator(
                  daysToKeepStr: '7',
                  numToKeepStr: '10'
          )
  }

  stages {
    stage('Cleanup Workspace') {
      steps {
          cleanWs()
          sh """
          echo "Cleaned Up Workspace For Project"
          """
      }
    }

    stage('Code Checkout') {
      steps {
          checkout([
              $class: 'GitSCM',
              branches: [[name: '*/master']],
              userRemoteConfigs: [[url: 'https://github.com/jdfant/pipe.git']]
          ])
      }
    }

    stage('Version Testing') {
      steps {
          sh """
          echo "Checking versions"
          python --version
          pip --version
          """
      }
    }
    
    stage('Build Environment') {
      steps {
        sh '''
        code/create-virtualenv.sh 
        '''
      }
    }

    stage('Environment Testing') {
      steps {
        sh """
        code/pip-test.sh
        """
      }
    }

}
