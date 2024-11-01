pipeline {
    
    agent any 
    
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        
        stage('Checkout'){
           steps {
                git credentialsId: 'ffd68375-9868-42ec-b980-00e1cb8a41a2', 
                url: 'https://github.com/Seshadriraghav22/cicd-end-to-end.git',
                branch: 'main'
           }
        }

        stage('Build Docker'){
            steps{
                script{
                    sh '''
                    echo 'Buid Docker Image'
                    docker build -t seshadriraghav22/cicd-e2e:${BUILD_NUMBER} .
                    '''
                }
            }
        }

        stage('Push the artifacts'){
           steps{
                script{
                    docker.withRegistry('https://registry.hub.docker.com', 'dochub'){
                      sh '''
                        echo 'Push to Repo'
                        docker push seshadriraghav22/cicd-e2e:${BUILD_NUMBER}
                      '''
                    }
                }
            }
        }
        
        stage('Checkout K8S manifest SCM'){
            steps {
                git credentialsId: 'ffd68375-9868-42ec-b980-00e1cb8a41a2', 
                url: 'https://github.com/Seshadriraghav22/cicd-end-to-end.git',
                branch: 'main'
            }
        }
        
        stage('Update K8S manifest & push to Repo'){
            steps {
                script{
                    withCredentials([usernamePassword(credentialsId: 'ffd68375-9868-42ec-b980-00e1cb8a41a2', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        sh '''
                        cat deploy.yaml
                        sed -i '' "s/32/${BUILD_NUMBER}/g" deploy.yaml
                        cat deploy.yaml
                        git add deploy.yaml
                        git commit -m 'Updated the deploy yaml | Jenkins Pipeline'
                        git remote -v
                        git push https://github.com/Seshadriraghav22/cicd-end-to-end.git HEAD:main
                        '''                        
                    }
                }
            }
        }
    }
}
