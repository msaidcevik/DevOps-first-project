// This file is jenkins-server qith t3a.medium
pipeline {
    agent any
    tools {
        terraform 'terraform-01'
    }

    environment {
        USER_NAME = "ubuntu"
    }
    
    stages {
        stage('Github Checkout') {
            steps {
                git credentialsId: 'a5045a26-3ca3-4568-918c-2a68698cdb32', url: 'https://github.com/msaidcevik/tf-jenkins-demo.git'
            }
        }
        
        stage('Create docker image') {
            steps {
                sh 'docker build --force-rm -t "said23/roman-app:1.0" .'
                sh 'docker image ls'
            }
        }
        
        stage('Push Image to DockerHub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerhub-pwd')]) {
                        sh 'docker login -u said23 -p ${dockerhub-pwd}'
                        sh 'docker push said23/roman-app:1.0'
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init -no-color'
            }
        }
        
        stage('Terraform apply & destroy') {
            steps {
                sh 'terraform ${action} -auto-approve -no-color'
            }
        }
        
        stage('Wait the instance') {
            steps {
                script {
                    echo 'Waiting for the instance'
                    id = sh(script: 'aws ec2 describe-instances --filters Name=tag-value,Values=roman-app Name=instance-state-name,Values=running --query Reservations[*].Instances[*].[InstanceId] --output text',  returnStdout:true).trim()
                    sh 'aws ec2 wait instance-status-ok --instance-ids $id'
                }
            }
        }
        
        stage('docker pull & run') {
            steps {
                echo 'Connect the created instance'
                script {
                    env.SERVER_IP = sh(script: 'terraform output -raw server_public_ip', returnStdout:true).trim()
                }
                sh 'echo ${SERVER_IP}'
                
                sshagent(['firstkey1']) {
                    sh 'ssh -o StrictHostKeyChecking=no -l ubuntu ${SERVER_IP} docker pull said23/roman-app:1.0'
                    sh 'ssh -o StrictHostKeyChecking=no -l ubuntu ${SERVER_IP} docker run -d --name roman -p 80:80 said23/roman-app:1.0'
                } 
            }
        }
    }
}
