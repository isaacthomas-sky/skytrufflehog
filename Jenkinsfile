@Library('library@v-9') _

node {
    properties([pipelineTriggers([cron('0 */2 * * *')])])

    checkout scm

    dockerImgName = "trufflehog"
    currentHour = new Date().format("HH")
    excludeStrings = []

    stage("Build truffleHog docker image") {
        sh "docker build . --tag $dockerImgName"
    }

    stage("Read exclude strings file") {
        fileContent = readFile "exclude-strings.txt"
        fileContent.split().each { excludeStrings.add(it) }

        echo "EXCLUDE STRINGS = $excludeStrings"
    }

    stage("Run secret scanner") {
        secretsFound = false
        prefix = 'ffc-'

        try {
            if (currentHour == "02") {
                echo "*** RUNNING DAILY SCAN ***"
                secretsFound = secretScanner.scanWithinWindow(
                    'github-auth-token',
                    dockerImgName,
                    "defra",
                    prefix,
                    24,
                    excludeStrings,
                    "#secretdetection"
                )
            }
            else {
                echo "*** RUNNING HOURLY SCAN ***"
                secretsFound = secretScanner.scanWithinWindow(
                    'github-auth-token',
                    dockerImgName,
                    "isaacitanalyst",
                    prefix,
                    2,
                    excludeStrings,
                    "#secretdetection"
                )
            }
        } finally {
            if (secretsFound) {
                throw new Exception("Potential secret/s found in scan")
            }
        }
    }
}