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
              branches: [[name: '*/staging']],
              userRemoteConfigs: [[url: 'https://github.com/jdfant/pipe.git']]
          ])
      }
    }

    stage('Version Testing') {
      steps {
          sh """
          echo "Checking versions"
          python --version
          python3 --version
          pip --version
          pip3 --version
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

    stage('Code Analysis') {
        steps {
            sh """
            echo "Running Code Analysis"
            md5sum Jenkinsfile
            """
        }
    }

    stage('Build Deploy Code') {
        steps {
            sh """
            echo "Deploying Code to nowhere and everywhere, consecutively"
            """
        }
    }
    }   
}
