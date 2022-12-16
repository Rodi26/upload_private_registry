#!/bin/bash
# set -e Dont exit, helps with upsert

[[ -z "$TOKEN" ]] && echo "Please Set TOKEN to an API token" && exit 1
[[ -z "$HOST" ]] && echo "Please Set HOST to the hostname of Terraform Enterprise/Cloud" && exit 1
[[ -z "$ORGANIZATION_NAME" ]] && echo "Please Set ORGANIZATION_NAME to the Terraform Cloud/Enterprise organization name" && exit 1
[[ -z "$PROVIDER_NAME" ]] && echo "Please Set PROVIDER_NAME to the name of the provider (i.e. aws, ${PROVIDER_NAME}, etc...)" && exit 1
[[ -z "$PROVIDER_VERSION" ]] && echo "Please Set PROVIDER_VERSION to the semantic version (i.e. 1.0.0)" && exit 1
[[ -z "$GPG_KEY_ID" ]] && echo "Please Set GPG_KEY_ID to the id of the GPG key" && exit 1

scripts_directory="./scripts"
# Create Provider
${scripts_directory}/create-provider.sh

# Create Provider Versions
${scripts_directory}/create-provider-version.sh

# Upload Provider Checksum
SHASUMS_FILE="providers/${PROVIDER_NAME}/${PROVIDER_VERSION}/terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_SHA256SUMS" \
SHASUMS_SIG_FILE="providers/${PROVIDER_NAME}/${PROVIDER_VERSION}/terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_SHA256SUMS.sig" \
HOST=${HOST} \
${scripts_directory}/upload-provider-version-shasums.sh

# Create Provider Version Platforms
OS="darwin" \
ARCH="amd64" \
ZIP_FILE="providers/${PROVIDER_NAME}/${PROVIDER_VERSION}/terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_darwin_amd64.zip" \
FILENAME="terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_darwin_amd64.zip" \
HOST=${HOST} \
${scripts_directory}/create-provider-version-platform.sh

OS="linux" \
ARCH="amd64" \
ZIP_FILE="providers/${PROVIDER_NAME}/${PROVIDER_VERSION}/terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_linux_amd64.zip" \
FILENAME="terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_linux_amd64.zip" \
HOST=${HOST} \
${scripts_directory}/create-provider-version-platform.sh

OS="windows" \
ARCH="amd64" \
ZIP_FILE="providers/${PROVIDER_NAME}/${PROVIDER_VERSION}/terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_windows_amd64.zip" \
FILENAME="terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_windows_amd64.zip" \
HOST=${HOST} \
${scripts_directory}/create-provider-version-platform.sh

# Upload Binaries
OS="darwin" \
ARCH="amd64" \
ZIP_FILE="providers/${PROVIDER_NAME}/${PROVIDER_VERSION}/terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_darwin_amd64.zip" \
HOST=${HOST} \
${scripts_directory}/upload-provider-version-platform-zip.sh

OS="linux" \
ARCH="amd64" \
ZIP_FILE="providers/${PROVIDER_NAME}/${PROVIDER_VERSION}/terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_linux_amd64.zip" \
HOST=${HOST} \
${scripts_directory}/upload-provider-version-platform-zip.sh

OS="windows" \
ARCH="amd64" \
ZIP_FILE="providers/${PROVIDER_NAME}/${PROVIDER_VERSION}/terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_windows_amd64.zip" \
HOST=${HOST} \
${scripts_directory}/upload-provider-version-platform-zip.sh
