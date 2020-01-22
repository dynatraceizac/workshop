#!/bin/bash

if [ $# -lt 1 ]
then
  echo "Perfspec file name is required"
  exit 1
else
  PERF_SPEC=`cat $1`
fi

# if did not pass in start/stop times in UTC format
# then use last few hours and now
if [ $# -lt 3 ]
then
  START_TIME=$(date -d "`date -u` - 6 hours" +'%s')
  END_TIME=$(date -u  +'%s')
else
  START_TIME=$2
  END_TIME=$3
fi

API_URL="http://localhost:8090/api/pitometer"

POST_DATA=$(cat <<EOF
{
    "timeStart": ${START_TIME},
    "timeEnd": ${END_TIME},
    "perfSpec": ${PERF_SPEC}
} 
EOF
)
echo "POST_DATA = $POST_DATA"
echo ""
json_result=$(curl -X POST ${API_URL} \
    --silent \
    -H "Content-type: application/json" \
    -d "${POST_DATA}")

result=$(echo $json_result | jq -r '.result')

# show the result of pass or fail
echo "json_result = $(echo $json_result | jq -r '.')"

# extra logic to pass or fail the script
echo ""
echo "json_result = $result"
if [ "$result" = "fail" ]; then
  echo "Failed quality gate" 
  exit 1
else
  echo "Passed quality gate" 
  exit 0
fi