#!/bin/bash

clear

# validate passed two arguments
if [ $# -lt 2 ]
then
  echo "missing arguments. Expect <DYNATRACE_API_URL> <DYNATRACE_API_TOKEN>"
  echo "example: ./pushevent.sh https://<YOUR TENANT>.live.dynatrace.com <YOUR API TOKEN>"
  exit 1
fi

# if passed in a trailing slash then don't add it again
if [[ "$1" == */ ]]
then
    DYNATRACE_API_URL="${1}api/v1/events"
else
    DYNATRACE_API_URL="${1}/api/v1/events"
fi

# set the token
DYNATRACE_API_TOKEN="${2}"

# build up the API request payload
POST_DATA=$(cat <<EOF
{
    "eventType": "CUSTOM_DEPLOYMENT",
    "attachRules": {
            "tagRule": [
                {
                    "meTypes":"SERVICE",
                    "tags": [
                        {
                            "context": "ENVIRONMENT",
                            "key": "app",
                            "value": "keptn-orders"
                        }
                    ]
                }
            ]
    },
    "deploymentName" : "Mock Deployment for keptn-orders",
    "deploymentVersion" : "Mock version",
    "deploymentProject" : "keptn-orders",
    "source" : "Manual Script",
    "ciBackLink" : "http://mock-ci-link",
    "customProperties" : {
        "JenkinsUrl" : "http://mock-jenkins-link",
        "BuildUrl" : "http://mock-build-link",
        "GitCommit" : "Mock commit"
    }
  }
EOF
)

# make the API call 
echo "Pushing event to: ${DYNATRACE_API_URL}"
echo ""

curl -X POST "${DYNATRACE_API_URL}" \
    -H "Content-type: application/json" \
    -H "Authorization: Api-Token ${DYNATRACE_API_TOKEN}" \
    -d "${POST_DATA}"

echo ""
echo ""