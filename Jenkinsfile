pipeline {

    agent any
/*
	tools {
        maven "maven3"
    }
*/
    environment {
		registry = "utpalbhattacharjee/vproappdock"
		registryCredentials = 'dockerhub'
    }

    stages{
        stage('BUILD'){
            steps {
                sh 'mvn clean install -DskipTests'
            }
            post {
                success {
                    echo 'Now Archiving...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }

        stage('UNIT TEST'){
            steps {
                sh 'mvn test'
            }
        }

        stage('INTEGRATION TEST'){
            steps {
                sh 'mvn verify -DskipUnitTests'
            }
        }


		stage('Build App Image') {
			steps {
				script {
				  dockerImage = docker.build registry + ":V$BUILD_NUMBER"
				}
			}
		}
		stage('uploaded image') {
			steps {
				script {
				  docker.withRegistry('', registryCredentials) {
					dockerImage.push("V$BUILD_NUMBER")
					dockerImage.push('latest')
				  }
				}
			}
		}
		stage('Remove Unused docker image') {
			steps {
				sh "docker rmi $registry:V$BUILD_NUMBER"
			}
		}
		stage('Kubernetes Deploy') {
			agent {label 'KOPS'}
				steps {
					sh "helm upgrade --install --force vprofile-stack helm/vprofilecharts --set appimage=${registry}:V${BUILD_NUMBER} --namespace prod"
				}
		}
    }

}






















