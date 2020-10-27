Enable-Disable Azure Hybrid Benefit(AHUB) for Windows VM and Windows VMSS
=========================================================================

            

**DESCRIPTION**


This PowerShell Script Enables/Disables Azure Hybrid Benefit for Virtual Machine/Virtual Machine Scalesets in a given Subbscription/Resource Group or individual Resources.


More on AHUB Benefit 
here


Savings work only if you already have on-premises Windows Server licenses with Software Assurance.


**REQUIRED**


1. AzureSubscriptionName - parameter that allows scoping VMs to a particular  Subscription.
3. AzureResourceGroup - parameter to input ResourceGroup name
2. Resource - Choose between VM, VMSS, 'VM,VMSS'


**OPTIONAL**


1. VMSSName - parameter that allows scoping only a particular VMSS (Works with Resource parameter as VMSS)
2. VMName - parameter that allows scoping only a particular VM (Works
with Resource parameter as VM)


**Example**


#Below is the option to Enable AHUB in all VMSS in a particular ResourceGroup


# .\AHUBLicensing.ps1 -AzureSubscriptionName 'SubscriptionName' -AzureResourceGroup 'ResourceGrpName' -Resource VMSS -LicenseType Windows_Server     


#Below is the option to Disable AHUB in all VM in a particular ResourceGroup


# .\AHUBLicensing.ps1 -AzureSubscriptionName 'SubscriptionName' -AzureResourceGroup 'ResourceGrpName' -Resource VM -LicenseType None


#Below is the option to Enable AHUB in a single VMSS in a particular ResourceGroup


# .\AHUBLicensing.ps1 -AzureSubscriptionName 'SubscriptionName' -AzureResourceGroup 'ResourceGrpName' -Resource VMSS -LicenseType Windows_Server -VMSSName 'VMSSName'


#Below is the option to Disable AHUB in a single VM in a particular ResourceGroup


# .\AHUBLicensing.ps1 -AzureSubscriptionName 'SubscriptionName' -AzureResourceGroup 'ResourceGrpName' -Resource VM -LicenseType None -VMName 'VMName'


 


 

 

        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
