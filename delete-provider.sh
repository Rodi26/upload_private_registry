#!/bin/bash
set -e

[[ -z "$TOKEN" ]] && echo "Please Set TOKEN to an API token" && exit 1
[[ -z "$HOST" ]] && echo "Please Set HOST to the hostname of Terraform Enterprise/Cloud" && exit 1
[[ -z "$ORGANIZATION_NAME" ]] && echo "Please Set ORGANIZATION_NAME to the Terraform Cloud/Enterprise organization name" && exit 1
[[ -z "$PROVIDER_NAME" ]] && echo "Please Set PROVIDER_NAME to the name of the provider (i.e. aws, random, etc...)" && exit 1

registry_name="private"
provider_namespace="${ORGANIZATION_NAME}"

curl -s -X DELETE --location "https://${HOST}/api/v2/organizations/${ORGANIZATION_NAME}/registry-providers/${registry_name}/${provider_namespace}/${PROVIDER_NAME}" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/vnd.api+json"
