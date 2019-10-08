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
				echo "${APIGEE_USR}"
		}}
    stage('Store Credentials'){
      steps{
        echo "$WORKSPACE"
        sh "rm -rf $WORKSPACE/features/support/credentials"
        sh "mkdir $WORKSPACE/features/support/credentials"
        echo "Storing Client Id"
        sh "touch $WORKSPACE/features/support/credentials/client-id.txt"
        writeFile file: '$WORKSPACE/features/support/credentials/client-id.txt', text: "$CLIENT_USR}"
        sh "cat ${CLIENT_USR} > $WORKSPACE/features/support/credentials/client-id.txt"
        echo "Storing Client Secret"
        sh "cat ${CLIENT_PSW} > $WORKSPACE/features/support/credentials/client-secret.txt"
		  
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
