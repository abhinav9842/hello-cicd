node(){
    timeout(unit: 'SECONDS', time: 3600){
    stage('building the jar file'){
        echo 'Packaging the jar'
        sh 'mvn -DskipTests clean package'

    }
    }
}