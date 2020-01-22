#!/bin/bash

DYNATRACE_API_URL="${1}/api/v1/events"
DYNATRACE_API_TOKEN="${2}"

POST_DATA=$(cat <<EOF
{
    "eventType": "CUSTOM_ANNOTATION",
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
    "source": "${7}",
    "annotationType": "${8}",
    "annotationDescription": "${9}",
    "customProperties" : {
        "JenkinsUrl" : "${10}",
        "BuildUrl" : "${11}",
        "GitCommit" : "${12}"
    },
    "start": ${13},
    "end": ${14}
  }
EOF
)

echo $POST_DATA

curl -X POST ${DYNATRACE_API_URL} \
    -H "Content-type: application/json" \
    -H "Authorization: Api-Token ${DYNATRACE_API_TOKEN}" \
    -d "${POST_DATA}"

