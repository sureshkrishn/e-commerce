pipeline {
    agent any

    environment {
        DOCKER_CREDS = 'docker-hub-creds'
        DOCKER_USER = 'sureshkrishn'
        IMAGE_NAME = ''
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/sureshkrishn/e-commerce.git'
            }
        }

        stage('Build & Push') {
            steps {
                script {

                    if (env.BRANCH_NAME == 'dev') {
                        IMAGE_NAME = "${DOCKER_USER}/dev:latest"
                    } 
                    else if (env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'master') {
                        IMAGE_NAME = "${DOCKER_USER}/prod:latest"
                    } 
                    else {
                        error "Branch not supported"
                    }

                    sh "docker build -t ${IMAGE_NAME} ."

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
