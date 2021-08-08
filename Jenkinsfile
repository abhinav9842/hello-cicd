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
        stage('Deploy application'){
            echo 'Running Container'
            sh 'docker run -p 80:8080 --name hello-app hello-app:${BUILD_NUMBER}'
        }
        
    }
}
