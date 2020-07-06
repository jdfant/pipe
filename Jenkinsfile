pipeline {

    agent {
        node {
            label 'Standard-Builder'
        }
    }

    options {
        buildDiscarder logRotator( 
                    daysToKeepStr: '5', 
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

        stage('Python Version Testing') {
            steps {
                sh """
                echo "Checking Python2 & PIP2 versions"
                python --version
                pip --version
                echo "Checking Python3 & PIP3 versions"
                python3 --version
                pip3 --version
                echo "Checking Python 2 modules"
                pydoc modules
                echo "Checking Python 3 modules"
                pydoc3 modules
                """
            }
        }

        stage('NPM Testing') {
            steps {
                sh """
                echo "Simple NPM config test"
                npm config ls -l
                """
            }
        }

        stage('Shell Script') {
            steps {
                sh """
                scripts/build_stuff.sh
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
                branch 'master'
            }
            steps {
                sh """
                echo -e "Deploying Code to nowhere AND everywhere.\nSo OMNI!"
                """
            }
        }

    }   
}
