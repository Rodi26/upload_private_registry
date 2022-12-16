#!/bin/bash
set -e

[[ -z "$TOKEN" ]] && echo "Please Set TOKEN to an API token" && exit 1
[[ -z "$HOST" ]] && echo "Please Set HOST to the hostname of Terraform Enterprise/Cloud" && exit 1
[[ -z "$ORGANIZATION_NAME" ]] && echo "Please Set ORGANIZATION_NAME to the Terraform Cloud/Enterprise organization name" && exit 1
[[ -z "$PUBLIC_GPG_FILE" ]] && echo "Please Set PUBLIC_GPG_FILE to the path to the public GPG file" && exit 1
echo $PUBLIC_GPG_FILE
provider_namespace="${ORGANIZATION_NAME}"
gpg_public_contents=$(awk '{printf "%s\\n", $0}' ${PUBLIC_GPG_FILE})

# Create GPG key, output its key-id
(
curl -s -X POST --location "https://${HOST}/api/registry/private/v2/gpg-keys" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/vnd.api+json" \
  -d@- <<EOF
{
  "data": {
    "type": "gpg-keys",
    "attributes": {
      "namespace": "${provider_namespace}",
      "ascii-armor": "${gpg_public_contents}"
    }
  }
}
EOF
) | jq '.data.attributes."key-id"'
