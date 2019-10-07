pipeline {
	agent any
	tools {
		maven 'M2'
		jdk 'JDK'
		nodejs 'NODEJS'
	}

	stages {
		stage('Initial-Checks'){
			steps{
				sendNotifications 'STARTED'
				sh "npm -v"
				sh "mvn -v"
				echo $apigeeUsername
		}}
		stage('Deploy to Production') {
			steps {
				//deploy using maven plugin
				sh "mvn -f bdd-security-app/pom.xml install -Pprod -Dusername=${apigeeUsername} -Dpassword=${apigeePassword} -Dapigee.config.options=update"
			}
		}
		stage('Integration Tests') {
			steps {
				script {
					sh "cd $WORKSPACE && npm install"
					sh "cd $WORKSPACE && npm test"

					sh "cd $WORKSPACE && cp reports.json $WORKSPACE"
					cucumber fileIncludePattern: 'reports.json'
					build job: 'cucumber-report'
				}
			}
		}
	}

	post {
		always {
			sendNotifications currentBuild.result
		}
	}
}
