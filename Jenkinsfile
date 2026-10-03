pipeline {
    agent any

    environment {
        IMAGE_NAME     = 'jenkins-demo-app'
        CONTAINER_NAME = 'jenkins-demo-app'
        HOST_PORT      = '3001'
    }

    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    // Check the repo for new commits every ~2 minutes.
    // (For instant triggers, use a GitHub webhook - see README.)
    triggers {
        pollSCM('H/2 * * * *')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                // Runs `npm test` inside Docker; a failing test fails this stage.
                sh 'docker build --target test -t ${IMAGE_NAME}:test .'
            }
        }

        stage('Build') {
            steps {
                sh 'docker build --target production -t ${IMAGE_NAME}:${BUILD_NUMBER} -t ${IMAGE_NAME}:latest .'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker rm -f ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} \
                        -p ${HOST_PORT}:3000 --restart unless-stopped \
                        ${IMAGE_NAME}:latest
                    sleep 5
                    docker exec ${CONTAINER_NAME} wget -qO- http://localhost:3000/health
                '''
            }
        }
    }

    post {
        success {
            echo "Deployed build #${BUILD_NUMBER}. Open http://localhost:${HOST_PORT}"
        }
        failure {
            echo 'Pipeline failed - check the stage logs above.'
        }
        always {
            sh 'docker image prune -f || true'
        }
    }
}
