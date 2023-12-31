#!/bin/bash -l

execution_id=${1}
client_id=${2}
client_secret=${3}
realm=${4}
debug=${5}
repo_url=${6}
idm_base_url=${7}
workflow_api_base_url=${8}
origin_branch=${9}
feature_branch=${10}

export client_id=$client_id
export client_secret=$client_secret

if [[ "$debug" == "true" ]]; then
  echo "Debug Enabled"
  export HTTP_ENABLE_FILE_DEBUG=true
fi

secret_stk_login=$(curl --location --request POST "$idm_base_url/realms/$realm/protocol/openid-connect/token" \
    --header "Content-Type: application/x-www-form-urlencoded" \
    --data-urlencode "client_id=$client_id" \
    --data-urlencode "grant_type=client_credentials" \
    --data-urlencode "client_secret=$client_secret" | jq -r .access_token)

url="$workflow_api_base_url/workflows/$execution_id?loginType=CLIENT_ACCESS"

if [[ "$origin_branch" != "" ]]; then
    url="$url&originBranch=$origin_branch"
fi

if [[ "$feature_branch" != "" ]]; then
    url="$url&featureBranch=$feature_branch"
fi

http_code=$(curl -s -o script.sh -w '%{http_code}' "$url"  --header "Authorization: Bearer $secret_stk_login";)
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
    echo "{\"outputs\": {\"created_repository\": \"$repo_url\"}}" > stk-local-context.json
    bash script.sh
    result=$?
    echo "------------------------------------------------------------------------------------------"
    echo "----------------------------------------  Ending  ----------------------------------------"
    echo "------------------------------------------------------------------------------------------"
    exit $result
fi