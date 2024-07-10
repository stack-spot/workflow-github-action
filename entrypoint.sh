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
extra_inputs=${11}

export client_id=$client_id
export client_secret=$client_secret

secret_stk_login=$(curl -s --location --request POST "$idm_base_url/realms/$realm/protocol/openid-connect/token" \
    --header "Content-Type: application/x-www-form-urlencoded" \
    --data-urlencode "client_id=$client_id" \
    --data-urlencode "grant_type=client_credentials" \
    --data-urlencode "client_secret=$client_secret" | jq -r .access_token)

put_workflow_url="$workflow_api_base_url/workflows/$execution_id"

decoded_extra_inputs=$(echo $extra_inputs | base64 -d)
put_workflow_json="{\"extra_inputs\": $decoded_extra_inputs}"
echo $put_workflow_json

http_code=$(curl --request PUT -s -o output.json -w '%{http_code}' "$put_workflow_url" --header "Authorization: Bearer $secret_stk_login" --header 'Content-Type: application/json' --data "$put_workflow_json";)
if [[ "$http_code" -ne "200" ]]; then
    echo "HTTP_CODE:" $http_code
    echo "RESPONSE_CONTENT:" $(cat output.json)
    exit $http_code
fi

url="$workflow_api_base_url/workflows/$execution_id?loginType=CLIENT_ACCESS"

if [[ "$origin_branch" != "" ]]; then
    url="$url&originBranch=$origin_branch"
fi

if [[ "$feature_branch" != "" ]]; then
    url="$url&featureBranch=$feature_branch"
fi

http_code=$(curl -s -o script.sh -w '%{http_code}' "$url"  --header "Authorization: Bearer $secret_stk_login";)
if [[ "$http_code" -ne "200" ]]; then
    echo "HTTP_CODE:" $http_code
    echo "RESPONSE_CONTENT:"
    cat script.sh
    exit 1
else
    chmod +x script.sh
    echo "------------------------------------------------------------------------------------------"
    echo "---------------------------------------- Starting ----------------------------------------"
    echo "------------------------------------------------------------------------------------------"
    echo "{\"outputs\": {\"created_repository\": \"$repo_url\"}}" > stk-local-context.json
    bash script.sh
    result=$?
    if [[ "$debug" == "true" ]]; then
        cat ~/.stk/debug/http.txt
    fi
    echo "------------------------------------------------------------------------------------------"
    echo "----------------------------------------  Ending  ----------------------------------------"
    echo "------------------------------------------------------------------------------------------"
    exit $result
fi