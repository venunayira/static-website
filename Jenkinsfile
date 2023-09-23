currentBuild.displayName = "Static-Website-#"+currentBuild.number
pipeline {
    agent any

    environment {
        GIT_CREDENTIALS = credentials('github-ssh')
        DOCKER_CREDENTIALS = credentials('dockerhub-cred')
        IMAGE_VERSION = "${BUILD_NUMBER}"
    }

    parameters {
        string(name: 'ENVIRONMENT', defaultValue: 'dev', description: 'Deployment environment')
        booleanParam(name: 'DEPLOY', defaultValue: true, description: 'Deployment to environment')
    }


    stages {
        stage ("Git sync"){
            steps{
                // Check out a Git repository
                git branch: 'master',
                    credentialsId: env.GIT_CREDENTIALS,
                    url: 'git@github.com:venunayira/static-website.git'
            }
            
        }
        stage ("Build Image"){
            steps{
                script{
                    if(isUnix()){
                        sh "docker build -t venunayira/staticweb:${env.IMAGE_VERSION} ."
                    }
                    else{
                        bat "docker build -t venunayira/staticweb:${env.IMAGE_VERSION} ."
                    }
                }
            }
        }
        stage ("Publish Image"){
            steps{
                script{
                    if(isUnix()){
                        sh "echo ${env.DOCKER_CREDENTIALS_PSW} | docker login -u ${env.DOCKER_CREDENTIALS_USR} --password-stdin"
                        sh "docker push venunayira/staticweb:${env.IMAGE_VERSION}"
                    }
                    else{
                        bat "docker login -u ${env.DOCKER_CREDENTIALS_USR} -p ${env.DOCKER_CREDENTIALS_PSW}"
                        bat "docker push venunayira/staticweb:${env.IMAGE_VERSION}"
                    }
                }
            }
        }
        stage ("Deploy"){
            when{
                expression{
                    params.DEPLOY
                }
            }
            steps{
                script{
                    if(isUnix()){
                        sh "docker run -d --name staticweb${env.IMAGE_VERSION} -p 8090:80 venunayira/staticweb:${env.IMAGE_VERSION}"
                    }
                    else{
                        bat "docker run -d --name staticweb${env.IMAGE_VERSION} -p 8090:80 venunayira/staticweb:${env.IMAGE_VERSION}"
                    }
                }
            }
        }
    }
    post{
        always{
            script{
                if(isUnix()){
                    sh "docker logout"
                }
                else{
                    bat "docker logout"
                }
            }
        }
    }
}
