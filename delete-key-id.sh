#!/bin/bash
set -e

[[ -z "$TOKEN" ]] && echo "Please Set TOKEN to an API token" && exit 1
[[ -z "$HOST" ]] && echo "Please Set HOST to the hostname of Terraform Enterprise/Cloud" && exit 1
[[ -z "$ORGANIZATION_NAME" ]] && echo "Please Set ORGANIZATION_NAME to the Terraform Cloud/Enterprise organization name" && exit 1
[[ -z "$GPG_KEY_ID" ]] && echo "Please Set GPG_KEY_ID to the id of the GPG key" && exit 1

registry_name="private"
provider_namespace="${ORGANIZATION_NAME}"

curl -s -X DELETE --location "https://${HOST}/api/registry/${registry_name}/v2/gpg-keys/${ORGANIZATION_NAME}/${GPG_KEY_ID}" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/vnd.api+json"
