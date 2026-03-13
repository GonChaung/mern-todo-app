pipeline {
    agent any

    environment {
        PATH = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        DOCKER_HUB_USER = 'gonchaung'
        IMAGE_NAME = 'finead-todo-app'
        DOCKER_HUB_CREDS = 'docker-hub-credentials'
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building the application...'
                dir('TODO/todo_backend') {
                    sh 'npm install'
                }
                dir('TODO/todo_frontend') {
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }

        stage('Test') {
            steps {
                echo 'Running unit tests...'
                dir('TODO/todo_frontend') {
                    sh 'npm test -- --watchAll=false || true'
                }
                dir('TODO/todo_backend') {
                    sh 'npm test || true'
                }
            }
        }

        stage('Containerize') {
            steps {
                echo 'Creating Docker image...'
                sh 'docker --version'
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest ."
            }
        }

        stage('Push') {
            steps {
                echo 'Logging into Docker Hub and pushing image...'
                withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDS}", passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            sh "docker rmi ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest || true"
        }
    }
}