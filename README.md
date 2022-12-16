# Guide to Providers in the Private Registry

A guide to install providers into a Private Registry.

The process below details the API calls needed to create and upload a privately build Terraform Provider into the Private Module Registry.

In this readme we will refer to providers as being in one of the two buckets:
1. "Private Providers" - Providers that are built by the Customer, Close Source Code, and are **not** available in at [Registry](registry.terraform.io).
2. "Public Providers" - Providers that are built by HashiCorp or a Verified Publisher, Open Source Code, and are available in the [Registry](registry.terraform.io).

The process for Public and Private Providers is the same, however the GPG Key used will be different.

## Terraform Cloud and Enterprise Structure

There are several steps to create each of "objects" and there are dependencies as outlined in the diagram below:

![Sourced from https://whimsical.com/providers-in-pmr-FSSqqCsdBdDsqYhU5KYERX](images/provider-objects.png)

This process is the same for Private or Public providers, the difference will be in which GPG key to use.

## Scripts

All scripts are located in the [./scripts](./scripts/) folder.

In an effort to demonstrate the use of the scripts, the following Environment Variables should be set for all script calls:

1. `TOKEN` (required) - A user token that has permissions to perform the tasks.
2. `HOST` (required) - The hostname of the Terraform Enterprise instance. If using Terraform Cloud, set this to "app.terraform.io".
3. `ORGANIZATION_NAME` (required) - The name of the Organization in Terraform Enterprise or Terraform Cloud.

Example:
```sh
export TOKEN="xxxxxxxxxxxxxx.atlasv1.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
export HOST="firefly.tfe.rocks"
export ORGANIZATION_NAME="terraform-tom"
```

## GPG Keys

You will need a GPG key that was used to sign provider binaries.

A Public GPG Key will have format such as this:

```
-----BEGIN PGP PUBLIC KEY BLOCK-----
...
-----END PGP PUBLIC KEY BLOCK-----
```

The generated KEY ID will be the short version of the GPG Fingerprint, so it is predictable and repeatable.

> WARNING: The API will allow you to delete an in use GPG key, so be sure not to delete one that is currently being used or you will see failures on later runs!

### Public Providers

For public providers, you will need to add the HashiCorp public Key.

**Upload HashiCorp Public GPG Keys**

```sh
# Key-Id: DA418C88A3219F7B
PUBLIC_GPG_FILE="./GPG_Public/gpg" \
./scripts/create-key-id.sh

# Key-Id: 51852D87348FFC4C
PUBLIC_GPG_FILE="./GPG_Public/C874011F0AB405110D02105534365D9472D7468F.asc" \
./scripts/create-key-id.sh
```

### Private Providers

For more information on how to generate your own [GPG Key](gpg.md).
https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key

Place your public GPG key in the `keys/` directory, 

**Upload a Public GPG Key**

```sh
PUBLIC_GPG_FILE="keys/gpg.public" \
./scripts/create-key-id.sh
```

export PUBLIC_GPG_FILE=./GPG_Public/gpg
"DA418C88A3219F7B"
export PUBLIC_GPG_FILE=./GPG_Public/C874011F0AB405110D02105534365D9472D7468F.asc
"34365D9472D7468F"
export PUBLIC_GPG_FILE=./GPG_Public/mypgp
"3B253ABF906D3899"

### List Keys

**List Available GPG Keys**
3B253ABF906D3899
```sh
./scripts/list-key-ids.sh
```

## Create Provider

Rendez-vous à l'adresse suivante : https://releases.hashicorp.com/ et téléchargez les providers qui vous interessent linux et windows ainsi que le ficher SHA256SUMS et SHA256SUMS.sig

To get started the following steps must be performed:

1. Upload public GPG key, output will be a Key-Id.
2. Create Provider.
3. Create Provider Version, then upload SHA256SUMS and Sig.
4. Create Provider Version Platform, then upload zip file.

The next section provides scripts to assist and enable on the API calls needed.

### Create Scripts

**Create Provider**

```sh
  PROVIDER_NAME="random" \
./scripts/create-provider.sh
```

**Create Provider Version**

The GPG_KEY_ID is the key you created earlier.

```sh
PROVIDER_NAME="random" \
PROVIDER_VERSION="3.1.0" \
GPG_KEY_ID="51852D87348FFC4C" \
./scripts/create-provider-version.sh
```

**Upload SHASUMS and SHASUMS SIG**
ex : https://releases.hashicorp.com/terraform-provider-random/3.1.0/

> Note: This can be done multiple times to overwrite.

Example of a SHA256SUMS file:
```
a6818842b28d800f784e0c93284ff602b0c4022f407e4750da03f50b853a9a2c  terraform-provider-random_3.1.0_darwin_amd64.zip
e385e00e7425dda9d30b74ab4ffa4636f4b8eb23918c0b763f0ffab84ece0c5c  terraform-provider-random_3.1.0_linux_amd64.zip
0d4f683868324af056a9eb2b06306feef7c202c88dbbe6a4ad7517146a22fb50  terraform-provider-random_3.1.0_windows_amd64.zip
```

```sh
PROVIDER_NAME="random" \
PROVIDER_VERSION="3.1.0" \
SHASUMS_FILE="providers/random/3.1.0/terraform-provider-random_3.1.0_SHA256SUMS" \
SHASUMS_SIG_FILE="providers/random/3.1.0/terraform-provider-random_3.1.0_SHA256SUMS.sig" \
./upload-provider-version-shasums.sh
```

**Create Provider Version Platform**

Pensez pour vous à pousser la version windows. 

> Note: ZIP_FILE must be in the following format `terraform-provider-{PROVIDER_NAME}_{PROVIDER_VERSION}_{OS}_{ARCH}.zip`
> This is matched at run time with the items in the SHASUMS file.

```sh
PROVIDER_NAME="random" \
PROVIDER_VERSION="3.1.0" \
OS="linux" \
ARCH="amd64" \
ZIP_FILE="providers/random/3.1.0/terraform-provider-random_3.1.0_linux_amd64.zip" \
FILENAME="terraform-provider-random_3.1.0_linux_amd64.zip" \
./create-provider-version-platform.sh
```

```sh
PROVIDER_NAME="random" \
PROVIDER_VERSION="3.1.0" \
OS="darwin" \
ARCH="amd64" \
ZIP_FILE="providers/random/3.1.0/terraform-provider-random_3.1.0_darwin_amd64.zip" \
FILENAME="terraform-provider-random_3.1.0_darwin_amd64.zip" \
./create-provider-version-platform.sh
```

```sh
PROVIDER_NAME="random" \
PROVIDER_VERSION="3.1.0" \
OS="darwin" \
ARCH="arm64" \
ZIP_FILE="providers/random/3.1.0/terraform-provider-random_3.1.0_darwin_arm64.zip" \
FILENAME="terraform-provider-random_3.1.0_darwin_arm64.zip" \
./create-provider-version-platform.sh
```

**Upload Provider Version Platform Zip**

```sh
PROVIDER_NAME="random" \
PROVIDER_VERSION="3.1.0" \
OS="linux" \
ARCH="amd64" \
ZIP_FILE="providers/random/3.1.0/terraform-provider-random_3.1.0_linux_amd64.zip" \
./upload-provider-version-platform-zip.sh
```

```sh
PROVIDER_NAME="random" \
PROVIDER_VERSION="3.1.0" \
OS="darwin" \
ARCH="arm64" \
ZIP_FILE="providers/random/3.1.0/terraform-provider-random_3.1.0_darwin_arm64.zip" \
./upload-provider-version-platform-zip.sh
```

```sh
PROVIDER_NAME="random" \
PROVIDER_VERSION="3.1.0" \
OS="darwin" \
ARCH="amd64" \
ZIP_FILE="providers/random/3.1.0/terraform-provider-random_3.1.0_darwin_amd64.zip" \
./upload-provider-version-platform-zip.sh
```

### Delete Scripts

To undo mistakes.

**Delete GPG Key**

```sh
PUBLIC_GPG_FILE="./GPG_Public/mypgp" \
GPG_KEY_ID="3B253ABF906D3899" \
./delete-key-id.sh
```

**Delete Provider**

```sh
PROVIDER_NAME="google" \
./scripts/delete-provider.sh
```

**Delete Provider Version**

```sh
PROVIDER_NAME="random" \
PROVIDER_VERSION="3.1.0" \
./scripts/delete-provider-version.sh
```

**Delete Provider Version Platform**

```sh
PROVIDER_NAME="random" \
PROVIDER_VERSION="3.1.0" \
OS="linux" \
ARCH="amd64" \
./scripts/delete-provider-version-platform.sh
```

## Challenges

- Every module and workspace will need to add a source argument:
  ```hcl
  terraform {
    required_providers {
      random = {
        source = "app.terraform.io/ORGANIZATION_NAME/PROVIDER_NAME"
        version = "x.x.x"
      }
    }
  }
  ```
- Which public GPG key was used to sign a provider binary will need to be determined.

## Download Public Provider

Easy scripts to download the files needed to upload Public Providers to your Private Registry.

```sh
PROVIDER_NAME="random" \
PROVIDER_VERSION="3.1.0" \
OS="linux" \
ARCH="amd64" \
./scripts/download-public-provider.sh

PROVIDER_NAME="random" \
PROVIDER_VERSION="3.1.0" \
OS="darwin" \
ARCH="amd64" \
./scripts/download-public-provider.sh

PROVIDER_NAME="random" \
PROVIDER_VERSION="3.1.0" \
OS="linux" \
ARCH="amd64" \
./scripts/download-public-provider.sh

PROVIDER_NAME="random" \
PROVIDER_VERSION="3.1.0" \
OS="darwin" \
ARCH="amd64" \
./scripts/download-public-provider.sh
```

## References

- https://www.terraform.io/registry/providers/publishing#creating-a-github-release
- Goreleaser: https://www.terraform.io/registry/providers/publishing#using-goreleaser-locally
- docs here: https://www.terraform.io/cloud-docs/registry/publish-providers
- API docs here: https://www.terraform.io/cloud-docs/api-docs/private-registry/providers
- https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key
- https://gist.github.com/jbonhag/2637b76b394ac3cee576e471b6d134eb
- https://gist.github.com/jbonhag/362cef97e1389a5d2bc7cab87fa1ba79#create-provider-version-platform
- https://github.com/hashicorp/terraform-provider-scaffolding
- https://github.com/hashicorp/terraform-website/pull/2137/files?short_path=13d2ff9#diff-13d2ff92be6f1e99ad1d0a0a60d6945f7d547cb0ed1ed0fb51beeceacb3fdcd3
- https://keybase.io/hashicorp/pgp_keys.asc?fingerprint=c874011f0ab405110d02105534365d9472d7468f
