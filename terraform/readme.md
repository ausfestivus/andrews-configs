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

- `azureControlPlaneHome`
  - Move the RG name to a proper var.
  - Fix the tagging
  - VPN config to Home. https://trello.com/c/msf6qcO6
- `LAB` (with optional peer to the ControlPlane)
- `DNS`
- `OS CUSTOMISE`
  - standard cloud host build steps
  - apt config to install patches etc
- `modularisation`

----------------------------------------------

## Terraform and Azure

**vendor documentation**

Start with the basic terraform install/config instructions available from https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure



**information**
 - `setEnvCredentials.sh` currently only sets the environment variables to use a SP in the Diaxion AAD.
 - `azureControlPlaneHome` builds the controlplane vNet and services:
  - jumphost (ubuntu VM)


## Terraform and AWS
