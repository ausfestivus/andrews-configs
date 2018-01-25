# terraform readme

This directory contains all the modules needed to build my various CSP environments. The principles for these environments include:

- all CSP entities are ephemeral
- all CSP elements are defined from here

The rules and configuration details are maintained in https://confluence.diaxion.com/display/~abest/Home+Systems+Information

**naming**

- Capitalisation **MUST** by `camelCase`.
- Azure related directories and files **MUST** start with `azure`
- AWS related directories and files **MUST** start with `aws`

**TODO**

See https://github.com/andrew-best-diaxion/andrews-configs/issues

----------------------------------------------

## Terraform and Azure

**vendor documentation**

Start with the basic terraform install/config instructions available from https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure

Configuration Syntax
https://www.terraform.io/docs/configuration/syntax.html

Terraform and Environment variables
https://www.terraform.io/docs/configuration/environment-variables.html

**information**
 - `setEnvCredentials.sh` currently only sets the environment variables to use a SP in the Diaxion AAD.
 - `azureControlPlaneHome` builds the controlplane vNet and services:
  - jumphost (ubuntu VM)


## Terraform and AWS
