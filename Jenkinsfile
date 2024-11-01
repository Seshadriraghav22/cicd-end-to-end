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

       
        
        stage('Update K8S manifest & push to Repo') {
            steps {
                script {
                      withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                        sh '''
                        echo 'Updating K8S manifest'
                        sed -i "s/:rk/:${BUILD_NUMBER}/g" deploy/deploy.yaml
                        git config --global user.email "seshadriraghav24@gmail.com"
                        git config --global user.name "Seshadriraghav22"
                        git add deploy/deploy.yaml
                        git commit -m 'Updated the deploy yaml | Jenkins Pipeline'
                        git remote set-url origin https://Seshadriraghav22:${GITHUB_TOKEN}@github.com/Seshadriraghav22/cicd-end-to-end.git
                        git push origin main
                        '''                        
                    }
                }
            }
        }
    }
}
