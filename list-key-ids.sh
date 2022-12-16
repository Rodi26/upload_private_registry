#!/bin/bash
set -e

[[ -z "$TOKEN" ]] && echo "Please Set TOKEN to an API token" && exit 1
[[ -z "$HOST" ]] && echo "Please Set HOST to the hostname of Terraform Enterprise/Cloud" && exit 1
[[ -z "$ORGANIZATION_NAME" ]] && echo "Please Set ORGANIZATION_NAME to the Terraform Cloud/Enterprise organization name" && exit 1

provider_namespace="${ORGANIZATION_NAME}"

# List all GPG Key Ids
curl -s -X GET --location "https://${HOST}/api/registry/private/v2/gpg-keys?filter%5Bnamespace%5D=${provider_namespace}" \
  -H "Authorization: Bearer ${TOKEN}" | jq '.data[] | .attributes."key-id"'
