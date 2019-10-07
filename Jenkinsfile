pipeline {
	env.JAVA_HOME = tool 'JDK-1.8'
  agent any
	tools {
		maven '/usr/bin/mvn'
		jdk '/usr/bin/java'
	}

	stages {
		stage('Initial-Checks'){
			steps{
        echo "Checking npm version"
				sh "npm -v"
        echo "Checking maven version"
				sh "mvn -v"
        echo "Echoing apigee username"
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
}
