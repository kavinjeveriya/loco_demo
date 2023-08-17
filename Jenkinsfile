pipeline {
    agent { label 'master' }
    stages {
        stage('Take Choice From user') {
            steps {
                // getting parameter if build trigger mannual 
                echo ${BUILD_FOR_DEPLOYMENT}
            }
            post {
                failure {
                slackSend channel: 'loco_testing', message: "*****Pipeline failed on user inpi*****"
                }
            }
        }
        stage('Building Image') {
            when { expression { params.BUILD_FOR_DEPLOYMENT == yes } }
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
