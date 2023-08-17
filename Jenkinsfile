pipeline {
    agent { label 'master' }
    stages {
        stage('Take Choice From user') {
            steps {
                // getting parameter if build trigger mannual 
                echo "${BUILD_FOR_DEPLOYMENT}"
            }
            post {
                failure {
                slackSend channel: '#loco_testing', message: "*****Pipeline failed on user input*****"
                }
            }
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
