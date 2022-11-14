# Hub and Spoke Architecture on Azure

## Architecture

The following diagram shows a simplified version of a Hub and Spoke architecture on Azure using PowerShell.

<img src="architecture.jpg" alt="drawing" width="90%"/>

## Getting started

- Install PowerShell Module. Run the following command within your PowerShell: 
  > `Install-Module -Name Az`
- **Setup basic Hub infrastructure:**
  - There are two options of running the scripts:
    1. Running everything with one single execution: [`.\main.ps1`](main.ps1)
    2. Running all scripts one after another manually. Consider the order of execution of [`main.ps1`](main.ps1)
  - **Hint:** All variabels will be managed centrally within [`_variables.ps1`](_variables.ps1) file.
- **Setup Connection to On-Prem:**
  - Run scripts consisting of ExpressRoute configuration
  - Make sure that you deploy the ExpressRoute into the subnet within the previously created infrastructure

## Network

- **Hint:**
  - ENV: Describes the development environment. (dev, staging, prod, etc.)
  - LOCATION: Describes the Region in Azure. (westeurope, eastus, etc.)

### Hub VNET

- Name: `vnet-hub-{ENV}-{LOCATION}-001`
- Example network: `53.1.0.0/24`

#### Subnets

The following table shows the network segmentation consisting of all existing subnets.

| Subnet address | Netmask         | Range of addresses      | Useable IPs             | Hosts | Subnet name                              |
|----------------|-----------------|-------------------------|-------------------------|-------|--------------------------------------|
| 53.1.0.0/26    | 255.255.255.192 | 53.1.0.0 - 53.1.0.63    | 53.1.0.1 - 53.1.0.62    | 62    | -                                    |
| 53.1.0.64/27   | 255.255.255.224 | 53.1.0.64 - 53.1.0.95   | 53.1.0.65 - 53.1.0.94   | 30    | snet-vnet-er-gw-{ENV}-{LOCATION}-001                      |
| 53.1.0.96/27   | 255.255.255.224 | 53.1.0.96 - 53.1.0.127  | 53.1.0.97 - 53.1.0.126  | 30    | -                                    |
| 53.1.0.128/26  | 255.255.255.192 | 53.1.0.128 - 53.1.0.191 | 53.1.0.129 - 53.1.0.190 | 62    | AzureFirewallSubnet               |
| 53.1.0.192/28  | 255.255.255.240 | 53.1.0.192 - 53.1.0.207 | 53.1.0.193 - 53.1.0.206 | 14    | snet-dns-pr-inbound-{ENV}-{LOCATION}-001   |
| 53.1.0.208/28  | 255.255.255.240 | 53.1.0.208 - 53.1.0.223 | 53.1.0.209 - 53.1.0.222 | 14    | snet-dns-pr-outbound-{ENV}-{LOCATION}-001 |
| 53.1.0.224/28  | 255.255.255.240 | 53.1.0.224 - 53.1.0.239 | 53.1.0.225 - 53.1.0.238 | 14    | snet-private-link-{ENV}-{LOCATION}-001     |
| 53.1.0.240/28  | 255.255.255.240 | 53.1.0.240 - 53.1.0.255 | 53.1.0.241 - 53.1.0.254 | 14    | -                                    |

### Application Gateways VNET

- Name: `vnet-agw-{ENV}-{LOCATION}-001`
- Example network: `53.2.0.0/23`

#### Subnets

The following table shows the network segmentation consisting of all existing subnets.

| Subnet address | Netmask         | Range of addresses      | Useable IPs             | Hosts | Subnet name                 |
|----------------|-----------------|-------------------------|-------------------------|-------|-------------------------|
| 53.2.0.0/24    | 255.255.255.0   | 53.2.0.0 - 53.2.0.255   | 53.2.0.1 - 53.2.0.254   | 254   | snet-agw-{ENV}-{LOCATION}-001 |
| 53.2.1.0/25    | 255.255.255.128 | 53.2.1.0 - 53.2.1.127   | 53.2.1.1 - 53.2.1.126   | 126   | -                       |
| 53.2.1.128/26  | 255.255.255.192 | 53.2.1.128 - 53.2.1.191 | 53.2.1.129 - 53.2.1.190 | 62    | AzureBastionSubnet |
| 53.2.1.192/26  | 255.255.255.192 | 53.2.1.192 - 53.2.1.255 | 53.2.1.193 - 53.2.1.254 | 62    | -                       |
