pipeline {
    agent {
        kubernetes {
            yamlFile 'jenkins-agent.yml'
        }
    }

    environment {
        DOCKER_REGISTRY = "10.101.100.160:8083"
        IMAGE_NAME = "node-app"                
        IMAGE_TAG = "latest"                            
        NEXUS_CREDENTIALS = credentials('nexus') 
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'k8s_task', url: 'https://github.com/mahmoud254/jenkins_nodejs_example.git'
            }
        }

        stage('Build') {
            steps {
                script {
                  
                     sh  """
                        docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -f dockerfile .
                       
                        """
                }
            }
        }

        stage('Push to Nexus') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'nexus', passwordVariable: 'NEXUS_PASSWORD', usernameVariable: 'NEXUS_USERNAME')]) {
                        sh """
                            docker login -u ${NEXUS_USERNAME} -p ${NEXUS_PASSWORD} ${DOCKER_REGISTRY}
                            docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_REGISTRY}/repository/docker-repo/${IMAGE_NAME}:${IMAGE_TAG}
                            docker push ${DOCKER_REGISTRY}/repository/docker-repo/${IMAGE_NAME}:${IMAGE_TAG}
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline successfully executed!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
