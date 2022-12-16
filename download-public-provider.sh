#!/bin/bash
set -e

[[ -z "$PROVIDER_NAME" ]] && echo "Please Set PROVIDER_NAME to the name of the provider (i.e. aws, random, etc...)" && exit 1
[[ -z "$PROVIDER_VERSION" ]] && echo "Please Set PROVIDER_VERSION to the semantic version (i.e. 1.0.0)" && exit 1
[[ -z "$OS" ]] && echo "Please Set OS to the os of the provider binary (i.e. linux, darwin, etc...)" && exit 1
[[ -z "$ARCH" ]] && echo "Please Set ARCH to the architecture of the provider binary (i.e. amd64)" && exit 1

folder_name="providers/${PROVIDER_NAME}/${PROVIDER_VERSION}"
zip_name="${folder_name}/terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_${OS}_${ARCH}.zip"

# create folder
mkdir -p ${folder_name}

# https://releases.hashicorp.com/terraform-provider-random/3.1.0/terraform-provider-random_3.1.0_linux_amd64.zip
curl -s -X GET \
  -o ${zip_name} \
  --location "https://releases.hashicorp.com/terraform-provider-${PROVIDER_NAME}/${PROVIDER_VERSION}/terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_${OS}_${ARCH}.zip"

# https://releases.hashicorp.com/terraform-provider-random/3.1.0/terraform-provider-random_3.1.0_SHA256SUMS
curl -s -X GET \
  -o ${folder_name}/terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_SHA256SUMS \
  --location "https://releases.hashicorp.com/terraform-provider-${PROVIDER_NAME}/${PROVIDER_VERSION}/terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_SHA256SUMS"

# https://releases.hashicorp.com/terraform-provider-random/3.1.0/terraform-provider-random_3.1.0_SHA256SUMS.sig
curl -s -X GET \
  -o ${folder_name}/terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_SHA256SUMS.sig \
  --location "https://releases.hashicorp.com/terraform-provider-${PROVIDER_NAME}/${PROVIDER_VERSION}/terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_SHA256SUMS.sig"
