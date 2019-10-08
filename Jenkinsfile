pipeline {
	agent any
	tools {
		maven 'M3'
		jdk 'OpenJDK8'
	}
  environment {
    APIGEE = credentials('jenkins-apigee-creds')
  }

	stages {
		stage('Initial-Checks'){
			steps{
				sh "npm -v"
				sh "mvn -v"
				echo "${apigeeUsername}"
		}}
		stage('Deploy to Production') {
			steps {
				//deploy using maven plugin
				sh "mvn -f bdd-security-app/pom.xml install -Pprod
-Dusername=${APIGEE_USR} -Dpassword=${APIGEE_PSW} -Dapigee.config.options=update"
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
