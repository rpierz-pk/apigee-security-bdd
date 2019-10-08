pipeline {
	agent any
	tools {
		maven 'M3'
		jdk 'OpenJDK8'
	}
  environment {
    APIGEE = credentials('apigee')
    CLIENT = credentials('client')
  }


	stages {
		stage('Initial-Checks'){
			steps{
				sh "npm -v"
				sh "mvn -v"
		}}
    stage('Store Credentials'){
      steps{
        cd $WORKSPACE
        echo "$WORKSPACE"
        sh "rm -rf features/support/credentials"
        sh "mkdir features/support/credentials"
        echo "Storing Client Id"
        sh "touch features/support/credentials/client-id.txt"
        writeFile(file: 'features/support/credentials/client-id.txt', text: "testData")
        
        echo "Storing Client Secret"
        sh "touch $WORKSPACE/features/support/credentials/client-secret.txt"
        writeFile(file: '$WORKSPACE/features/support/credentials/client-secret.txt', text: "${CLIENT_PSW}")
      }
    }
    stage('Deploy to Production') {
			steps {
				//deploy using maven plugin
				sh "mvn -f bdd-security-app/pom.xml install -Pprod -Dusername=${APIGEE_USR} -Dpassword=${APIGEE_PSW} -Dapigee.config.options=update"
			}
		}
		stage('Integration Tests') {
			steps {
				script {
          sh "rm -rf node_modules/*/.git/"
					sh "cd $WORKSPACE && npm install"
					sh "cd $WORKSPACE && npm test"

					sh "cd $WORKSPACE"
          sh "cat reports.json"
					cucumber fileIncludePattern: 'reports.json'
					build job: 'cucumber-report'
				}
			}
		}
  }
}
