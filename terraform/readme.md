# terraform readme

This directory contains all the modules needed to build my various CSP environments. The principles for these environments include:

- all CSP entities are ephemeral
- all CSP elements are defined from here

The rules and configuration details are maintained in https://confluence.diaxion.com/display/~abest/Home+Systems+Information

**naming**

- Capitalisation **MUST** use `camelCase`.
- Azure related directories and files **MUST** start with `azure`
- AWS related directories and files **MUST** start with `aws`

**TODO**

See https://github.com/ausfestivus/andrews-configs/issues and filter by the "terraform" tag.

**Description of components**

- `setEnvCredentials.sh` currently only sets the environment variables to use a SP in the Diaxion AAD.
- [azureControlPlaneHome](./azureControlPlaneHome/README.md) - my Azure control plane with a VPN to home.
- learning - if i'm doing any learning about Terraform the code will be in here.
- [quickVM](./quickVM/README.md) - a terraform config for a Linux VM and vNet. Useful when I need a linux VM quick.
- [quickVnet](./quickVnet/README.md) - a terraform config to build a basic vNet and single subnet.
- [VMonly](./VMonly/README.md) - a terraform config to build a VM only which attaches to an existing subnet. eg 'quickVnet'

----------------------------------------------

## Terraform and Azure

**vendor documentation**

Start with the basic terraform install/config instructions available from https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure

Configuration Syntax
https://www.terraform.io/docs/configuration/syntax.html

Terraform and Environment variables
https://www.terraform.io/docs/configuration/environment-variables.html

## Terraform and AWS
