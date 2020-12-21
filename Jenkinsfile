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

    stage('Code Checkout Develop') {
            when { branch 'develop'
      }
      steps {
          checkout([
              $class: 'GitSCM',
              branches: [[name: '*/develop']],
              userRemoteConfigs: [[url: 'https://github.com/jdfant/pipe.git']]
          ])
      }
    }

    stage('Code Checkout Staging') {
            when { branch 'staging'
      }
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
        echo "Executes code/create-virtualenv.sh script"
        '''
      }
    }

    stage('Environment Testing') {
      steps {
        sh """
        echo "Executes code/pip-test.sh script"
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
            echo "Deploying Code to nowhere and everywhere"
            """
        }
    }
 }
}
