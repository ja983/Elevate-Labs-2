// Works on Windows (bat) and Linux/macOS (sh) Jenkins agents.
def run(String cmd, boolean ignoreFail = false) {
    def status = isUnix() ? sh(script: cmd, returnStatus: true)
                          : bat(script: cmd, returnStatus: true)
    if (status != 0 && !ignoreFail) {
        error("Command failed (exit code ${status}): ${cmd}")
    }
}

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
                script {
                    run("docker build --target test -t ${env.IMAGE_NAME}:test .")
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    run("docker build --target production -t ${env.IMAGE_NAME}:${env.BUILD_NUMBER} -t ${env.IMAGE_NAME}:latest .")
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    run("docker rm -f ${env.CONTAINER_NAME}", true)   // ok if it doesn't exist yet
                    run("docker run -d --name ${env.CONTAINER_NAME} -p ${env.HOST_PORT}:3000 --restart unless-stopped ${env.IMAGE_NAME}:latest")
                    sleep 5
                    run("docker exec ${env.CONTAINER_NAME} wget -qO- http://localhost:3000/health")
                }
            }
        }
    }

    post {
        success {
            echo "Deployed build #${env.BUILD_NUMBER}. Open http://localhost:${env.HOST_PORT}"
        }
        failure {
            echo 'Pipeline failed - check the stage logs above.'
        }
        always {
            script {
                run('docker image prune -f', true)
            }
        }
    }
}
