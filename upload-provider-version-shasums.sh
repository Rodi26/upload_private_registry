#!/bin/bash
# set -e

[[ -z "$TOKEN" ]] && echo "Please Set TOKEN to an API token" && exit 1
[[ -z "$HOST" ]] && echo "Please Set HOST to the hostname of Terraform Enterprise/Cloud" && exit 1
[[ -z "$ORGANIZATION_NAME" ]] && echo "Please Set ORGANIZATION_NAME to the Terraform Cloud/Enterprise organization name" && exit 1
[[ -z "$PROVIDER_NAME" ]] && echo "Please Set PROVIDER_NAME to the name of the provider (i.e. aws, random, etc...)" && exit 1
[[ -z "$PROVIDER_VERSION" ]] && echo "Please Set PROVIDER_VERSION to the semantic version (i.e. 1.0.0)" && exit 1
[[ -z "$SHASUMS_FILE" ]] && echo "Please Set SHASUMS_FILE to the file containing the SHASUMS" && exit 1
[[ -z "$SHASUMS_SIG_FILE" ]] && echo "Please Set SHASUMS_SIG_FILE to the file containing the SHASUMS SIG" && exit 1

registry_name="private"
provider_namespace="${ORGANIZATION_NAME}"

# Read the provider version to get upload urls (that include a token)
response=$(curl -s -X GET --location "https://${HOST}/api/v2/organizations/${ORGANIZATION_NAME}/registry-providers/private/${provider_namespace}/${PROVIDER_NAME}/versions/${PROVIDER_VERSION}" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/vnd.api+json")

shasum=$(echo $response | jq -r '.data.links."shasums-upload"')
shasum_sig=$(echo $response | jq -r '.data.links."shasums-sig-upload"')

curl -T ${SHASUMS_FILE} ${shasum}
curl -T ${SHASUMS_SIG_FILE} ${shasum_sig}
