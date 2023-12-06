#!/bin/bash -l

execution_id=$1
client_id=$2
client_secret=$3
realm=$4
debug=$5
repo_url=$6

if [[ "$debug" == "true" ]]; then
  echo "Debug Enabled"
  export HTTP_ENABLE_FILE_DEBUG=true
fi

secret_stk_login=$(curl --location --request POST "https://idm.stackspot.com/realms/$realm/protocol/openid-connect/token" \
    --header "Content-Type: application/x-www-form-urlencoded" \
    --data-urlencode "client_id=$client_id" \
    --data-urlencode "grant_type=client_credentials" \
    --data-urlencode "client_secret=$client_secret" | jq -r .access_token)

http_code=$(curl -s -o script.sh -w '%{http_code}' https://workflow-api.v1.stackspot.com/workflows/$execution_id --header "Authorization: Bearer $secret_stk_login";)
if [[ "$http_code" -ne "200" ]]; then
    echo "------------------------------------------------------------------------------------------"
    echo "---------------------------------------- Debug Starting ----------------------------------"
    echo "------------------------------------------------------------------------------------------"
    echo "HTTP_CODE:" $http_code
    echo "RESPONSE_CONTENT:"
    cat script.sh
    exit $http_code
    echo "------------------------------------------------------------------------------------------"
    echo "---------------------------------------- Debug Ending ------------------------------------"
    echo "------------------------------------------------------------------------------------------"
else
    echo "HTTP_CODE:" $http_code
    chmod +x script.sh
    echo "------------------------------------------------------------------------------------------"
    echo "---------------------------------------- Starting ----------------------------------------"
    echo "------------------------------------------------------------------------------------------"
    bash script.sh $repo_url
    result=$?
    echo "------------------------------------------------------------------------------------------"
    echo "----------------------------------------  Ending  ----------------------------------------"
    echo "------------------------------------------------------------------------------------------"
    exit $result
fi