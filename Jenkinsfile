pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh './gradlew build --no-daemon'
                archiveArtifacts artifacts: 'dist/trainSchedule.zip'
            }
        }
        stage('Build docker Image11'){
            when{
                branch 'master'
            }
            steps{
                script{
                    app=docker.build('pnwrkavita/train-schedule1')
                 
                }
            }
        }
        stage('Push Docker Image in Docker hub'){
            when{
                branch 'master'
            }
            steps{
                script{
                    docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_login'){
                        
                        app.push('latest')
                    }
                }
            }
        }
        stage('DeploytoStaging') {
            when {
                branch 'master'
            }
            steps {
                input 'Deploy to Production?'
                milestone(1)
                withCredentials([usernamePassword(credentialsId: 'webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script {
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker pull pnwrkavita/train-schedule1\""
                        try {
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker stop train-schedule1\""
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker rm train-schedule1\""
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker run --restart always --name train-schedule1 -p 5000:5000 -d pnwrkavita/train-schedule1\""
                    }
                }
            }
        }
    }
}
