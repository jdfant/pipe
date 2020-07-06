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
                    branches: [[name: '*/develop']], 
                    userRemoteConfigs: [[url: 'https://github.com/jdfant/pipe.git']]
                ])
            }
        }

        stage('Version Testing') {
            steps {
                sh """
                echo "Checking Python versions"
                python --version
                pip --version
                python3 --version
                pip3 --version
                """
            }
        }

        stage('Unit Testing') {
            steps {
                sh """
                echo "Simple NPM config test"
                npm config ls -l
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
            when {
                branch 'develop'
            }
            steps {
                sh """
                echo "Deploying Code to nowhere and everywhere, consecutively"
                """
            }
        }

    }   
}
