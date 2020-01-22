#!/bin/bash

DYNATRACE_API_URL="${1}/api/v1/events"
DYNATRACE_API_TOKEN="${2}"

POST_DATA=$(cat <<EOF
{
    "eventType": "CUSTOM_DEPLOYMENT",
    "attachRules": {
            "tagRule": [
                {
                    "meTypes":"${3}",
                    "tags": [
                        {
                            "context": "${4}",
                            "key": "${5}",
                            "value": "${6}"
                        }
                    ]
                }
            ]
    },
    "deploymentName" : "${7}",
    "deploymentVersion" : "${8}",
    "deploymentProject" : "${9}",
    "source" : "${10}",
    "ciBackLink" : "${11}",
    "customProperties" : {
        "JenkinsUrl" : "${12}",
        "BuildUrl" : "${13}",
        "GitCommit" : "${14}"
    }
  }
EOF
)

echo $POST_DATA

curl -X POST ${DYNATRACE_API_URL} \
    -H "Content-type: application/json" \
    -H "Authorization: Api-Token ${DYNATRACE_API_TOKEN}" \
    -d "${POST_DATA}"

