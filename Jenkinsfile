pipeline {
    agent any

    environment {
        DOCKER_CREDS = 'docker-hub-creds'
        DOCKER_USER = 'sureshkrishn'
        IMAGE_NAME = ''
    }

    stages {

        stage('Build & Push') {
            steps {
                script {

                    // Get current branch name
                    def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    echo "Current Branch: ${branch}"

                    // Decide image based on branch
                    if (branch == 'dev') {
                        IMAGE_NAME = "${DOCKER_USER}/dev:latest"
                    } 
                    else if (branch == 'main' || branch == 'master') {
                        IMAGE_NAME = "${DOCKER_USER}/prod:latest"
                    } 
                    else {
                        error "Branch not supported: ${branch}"
                    }

                    // Build image
                    sh "docker build -t ${IMAGE_NAME} ."

                    // Login & Push
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDS}", passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "echo ${PASS} | docker login -u ${USER} --password-stdin"
                        sh "docker push ${IMAGE_NAME}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh """
                    docker stop react-app || true
                    docker rm react-app || true
                    docker pull ${IMAGE_NAME}
                    docker run -d -p 80:80 --name react-app ${IMAGE_NAME}
                    """
                }
            }
        }

        stage('Cleanup') {
            steps {
                sh "docker system prune -f"
            }
        }
    }
}
