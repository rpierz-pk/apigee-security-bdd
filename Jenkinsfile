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
				bat "npm -v"
				bat "mvn -v"
				echo $apigeeUsername
		}}
		stage('Deploy to Production') {
			steps {
				//deploy using maven plugin
				bat "mvn -f pom.xml install -Pprod -Dusername=${apigeeUsername} -Dpassword=${apigeePassword} -Dapigee.config.options=update"
			}
		}
		stage('Integration Tests') {
			steps {
				script {
					bat "cd $WORKSPACE/test/integration && npm install"
					bat "cd $WORKSPACE/test/integration && npm test"

					bat "cd $WORKSPACE/test/integration && cp reports.json $WORKSPACE"
					cucumber fileIncludePAttern: 'reports.json'
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
