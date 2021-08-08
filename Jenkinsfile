node() {
    timeout(unit: 'SECONDS', time: 3600) {
        stage('Building jar file') {
            properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '7', numToKeepStr: '10')), pipelineTriggers([githubPush()])])
            checkout scm
            echo 'Packaging the jar'
            sh 'mvn -DskipTests clean package'
        }
        stage('Unit testing'){
            echo 'Executing unit tests'
            sh 'mvn test'
            junit 'target/surefire-reports/*.xml'
        }
        stage('Build DockerImage'){
            echo 'Building Docker Image'
            sh 'docker build . -t hello-app:${BUILD_NUMBER}'
        }
        stage('Uploading docker image to Nexus repo'){
            echo 'Uploading image to Nexus'
            withCredentials([usernamePassword(credentialsId: 'docker-login', passwordVariable: 'password', usernameVariable: 'username')]) {
                sh ''' docker login -u $username -p $password  34.131.24.68:8082
                    docker tag hello-app:${BUILD_NUMBER} 34.131.24.68:8082/repository/docker-repo/hello-app:${BUILD_NUMBER}
                    docker push 34.131.24.68:8082/repository/docker-repo/hello-app:${BUILD_NUMBER} '''
            }            
        }
        stage('Deploy application'){
            echo 'Running Container'
            sh '''docker stop hello-app || true && docker rm hello-app || true
                docker run -p 80:8080 --name hello-app -d 34.131.24.68:8082/repository/docker-repo/hello-app:${BUILD_NUMBER}'''
        }
        
    }
}
