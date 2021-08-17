node() {
    timeout(unit: 'SECONDS', time: 3600) {
        stage('Building jar file') {
            properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '7', numToKeepStr: '10')), pipelineTriggers([githubPush()])])
            checkout scm
            echo 'Packaging the jar'
            sh 'mvn -DskipTests clean package'
        }
        try {   
            stage('Unit testing'){
            echo 'Executing unit tests'
            sh 'mvn test'                
            }
        } finally {
            junit 'target/surefire-reports/*.xml'
        }
        stage('Build DockerImage'){
            echo 'Building Docker Image'
            sh 'docker build . -t hello-app:${BUILD_NUMBER}'
        }
        stage('Scan DockerImage'){
            withCredentials([usernamePassword(credentialsId: 'docker-login', passwordVariable: 'password', usernameVariable: 'username')]){
            echo 'Uploading docker image to staging repo for scanning'
            sh '''docker build . -t hello-app:${BUILD_NUMBER}
                    docker login -u $username -p $password  34.131.24.68:8083
                    docker tag hello-app:${BUILD_NUMBER} 34.131.24.68:8083/repository/staging-docker-repo/hello-app:${BUILD_NUMBER}
                    docker push 34.131.24.68:8083/repository/staging-docker-repo/hello-app:${BUILD_NUMBER}'''
            def imageLine = "34.131.24.68:8083/repository/staging-docker-repo/hello-app:${BUILD_NUMBER}"
            writeFile file: 'anchore_images', text: imageLine
            anchore name: 'anchore_images', engineCredentialsId: 'anchore-auth', bailOnFail: false
            }
        }
        stage('Uploading docker image to Nexus repo'){
            echo 'Uploading image to Nexus'
            withCredentials([usernamePassword(credentialsId: 'docker-login', passwordVariable: 'password', usernameVariable: 'username')]) {
                sh ''' docker login -u $username -p $password  34.131.24.68:8082
                    docker tag hello-app:${BUILD_NUMBER} 34.131.24.68:8082/repository/docker-repo/hello-app:${BUILD_NUMBER}
                    docker push 34.131.24.68:8082/repository/docker-repo/hello-app:${BUILD_NUMBER} '''
            }            
        }
        stage('Deploy application to kubernetes'){
            echo 'Modifying Deployment'
            sh '''kubectl set image deploy hello-cicd-deploy hello-cicd=34.131.24.68:8082/repository/docker-repo/hello-app:${BUILD_NUMBER} --record'''
        }
        
    }
}
