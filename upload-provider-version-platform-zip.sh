#!/bin/bash
set -e

[[ -z "$TOKEN" ]] && echo "Please Set TOKEN to an API token" && exit 1
[[ -z "$HOST" ]] && echo "Please Set HOST to the hostname of Terraform Enterprise/Cloud" && exit 1
[[ -z "$ORGANIZATION_NAME" ]] && echo "Please Set ORGANIZATION_NAME to the Terraform Cloud/Enterprise organization name" && exit 1
[[ -z "$PROVIDER_NAME" ]] && echo "Please Set PROVIDER_NAME to the name of the provider (i.e. aws, random, etc...)" && exit 1
[[ -z "$PROVIDER_VERSION" ]] && echo "Please Set PROVIDER_VERSION to the semantic version (i.e. 1.0.0)" && exit 1
[[ -z "$OS" ]] && echo "Please Set OS to the os of the provider binary (i.e. linux, darwin, etc...)" && exit 1
[[ -z "$ARCH" ]] && echo "Please Set ARCH to the architecture of the provider binary (i.e. amd64)" && exit 1
[[ -z "$ZIP_FILE" ]] && echo "Please Set ZIP_FILE to the file containing the zip of the provider binary" && exit 1

registry_name="private"
provider_namespace="${ORGANIZATION_NAME}"

binary_url=$(curl -s -X GET --location "https://${HOST}/api/v2/organizations/${ORGANIZATION_NAME}/registry-providers/${registry_name}/${provider_namespace}/${PROVIDER_NAME}/versions/${PROVIDER_VERSION}/platforms/${OS}/${ARCH}" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/vnd.api+json" | jq -r '.data.links."provider-binary-upload"')

curl -T ${ZIP_FILE} ${binary_url}
