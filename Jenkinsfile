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
        
    }
}
