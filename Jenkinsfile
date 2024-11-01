pipeline {
    agent any 
    
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github', 
                url: 'https://github.com/Seshadriraghav22/cicd-end-to-end.git',
                branch: 'main'
            }
        }

        stage('Docker Image') {
            steps {
                script {
                    app = docker.build("seshadriraghav22/cicd-e2e:${IMAGE_TAG}")
                    app.inside {
                        sh 'echo $(curl localhost:8080)'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {		
                    docker.withRegistry('https://registry.hub.docker.com', 'dochub') {
                        app.push("${IMAGE_TAG}")
                        app.push("latest")
                    }
                }
            }
        }

        stage('Checkout K8S manifest SCM') {
            steps {
                git credentialsId: 'github', 
                url: 'https://github.com/Seshadriraghav22/cicd-end-to-end.git',
                branch: 'main'
            }
        }
        
        stage('Update K8S manifest & push to Repo') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github',variable: 'GITHUB_TOKEN')]) {
                        sh '''
                        echo 'Updating K8S manifest'
                        sed -i "s/32/${IMAGE_TAG}/g" deploy.yaml
                        git config --global user.email "you@example.com"
                        git config --global user.name "${GITHUB_USER}"
                        git add deploy.yaml
                        git commit -m 'Updated the deploy yaml | Jenkins Pipeline'
                        git remote set-url origin https://:${GITHUB_TOKEN}@github.com/Seshadriraghav22/cicd-end-to-end.git
                        git push origin main
                        '''                        
                    }
                }
            }
        }
    }
}
