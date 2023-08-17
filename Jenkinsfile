pipeline {
    agent { label 'master' }
    parameters {
        choice(name: 'BUILD_FOR_DEPLOYMENT', choices: ["yes", "no"], description: 'When no, Skip deployment stage')
	choice(name: 'BUILD_FOR_HPA', choices: ["no", "yes"], description: 'When no, Skip hpa stages')
	choice(name: 'BUILD_FOR_ROLLBACK', choices: ["no", "yes"], description: 'When no, Skip rollback stages')
    }
    stages {
        stage('Take Choice From user') {
            steps {
                // getting parameter if build trigger mannual 
                echo "${BUILD_FOR_DEPLOYMENT}"
            }
            post {
                failure {
                slackSend channel: 'loco_testing', message: "*****Pipeline failed on user inpi*****"
                }
            }
        }
        stage('Building Image') {
            when { expression { params.BUILD_FOR_DEPLOYMENT == "yes" } }
            steps {
                sh('''#!/bin/bash
                echo "echo building image with the container with ${BRANCH}" 
		        ''')
            }
            post {
                failure {
                slackSend channel: 'loco_testing', message: "*****image is not build*****"
                }
            }
        }
	stage('pushing image to ECR') {
            when { expression { params.BUILD_FOR_DEPLOYMENT == "yes" } }
            steps {
                sh('''#!/bin/bash
                echo "pushing image to ECR repo ${BRANCH}" 
		        ''')
            }
            post {
                failure {
                slackSend channel: 'loco_testing', message: "*****image not pushed.*****"
                }
            }
        }
	stage('deploying pods on cluster') {
            when { expression { params.BUILD_FOR_DEPLOYMENT == "yes" } }
            steps {
                sh('''#!/bin/bash
                echo "deploying pods on cluster" 
		        ''')
            }
            post {
                failure {
                slackSend channel: 'loco_testing', message: "*****pdos not deployed.*****"
                }
            }
        }
	stage('changing value of hpa') {
            when { expression { params.BUILD_FOR_HPA == "yes" } }
            steps {
		input(message: 'Please provide a HPA value:', ok: 'Continue', parameters: [string(name: 'HPA_VALUE', defaultValue: '', description: 'Enter your value')])
                echo "changing HPA value '$params.HPA_VALUE'" 
            }
            post {
		success {
                slackSend channel: 'loco_testing', message: "*****HPA value Change to '$params.HPA_VALUE'.*****"
                } 
                failure {
                slackSend channel: 'loco_testing', message: "*****changing hpa value failure.*****"
                }
            }
        }
	stage('Roll Back stage with image version') {
            when { expression { params.BUILD_FOR_ROLLBACK == "yes" } }
            steps {
                echo "changing  value" 
            }
            post {
		success {
                slackSend channel: 'loco_testing', message: "*****Roll back to particualr version successfule.*****"
                }   
                failure {
                slackSend channel: 'loco_testing', message: "*****Roll back to particualr version failure.*****"
                }
            }
        }
    }
    post {
        always {
            notifySlack(currentBuild.currentResult)
        }
    }
}

def notifySlack(String buildStatus = 'STARTED') {
    def color
    if (buildStatus == 'STARTED') {
        color = '#D4DADF'
    } else if (buildStatus == 'SUCCESS' ) {
        color = 'good'
    } else if (buildStatus == 'UNSTABLE') {
        color = 'warning'
    } else {
        color = 'danger'
    }
    def msg = "`${env.JOB_NAME}` build number #${env.BUILD_NUMBER}:`${buildStatus}`\n${env.BUILD_URL}   "
    slackSend(channel: '#loco_testing', color: color, message: msg)
}
