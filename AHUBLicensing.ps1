Param
(   
    [Parameter(Mandatory=$true)][String]$AzureSubscriptionName,
    [Parameter(Mandatory=$true)][String]$AzureResourceGroup,
    [Parameter(Mandatory=$false)][ValidateSet("VM","VMSS","VM,VMSS")][String]$Resource="VMSS",
	[Parameter(Mandatory=$false)][ValidateSet("Windows_Server","None")][String]$LicenseType="Windows_Server",
    [Parameter(Mandatory=$false)][String]$VMSSName="",
	[Parameter(Mandatory=$false)][String]$VMName=""
)

Function Update-VMSSLicense
{
    Param(
		[Parameter(Mandatory=$true)][String]$AzureResourceGroup,
		[Parameter(Mandatory=$false)][String]$VMSSName,
		[Parameter(Mandatory=$true)][String]$LicenseType
    )
	try
	{
		if(!$VMSSName)
		{
			foreach ($VMSSName in (Get-AzureRmVmss -ResourceGroupName $AzureResourceGroup).Name)
			{
				$vmss = Get-AzureRmVmss -ResourceGroupName $AzureResourceGroup -VMScaleSetName $VMSSName
				$vmss.VirtualMachineProfile.LicenseType = $LicenseType
				Write-Output ""
				Write-Output " Updating VMSS : ['$($VMSSName)'] with License :['$($LicenseType)'] Started"
				Update-AzureRmVmss -ResourceGroupName $AzureResourceGroup -VMScaleSetName $VMSSName -VirtualMachineScaleSet $vmss -Verbose:$false
				Write-Output " Updating VMSS : ['$($VMSSName)'] with License :['$($LicenseType)'] Completed"
			}
		}
		else
		{
			$vmss = Get-AzureRmVmss -ResourceGroupName $AzureResourceGroup -VMScaleSetName $VMSSName
			$vmss.VirtualMachineProfile.LicenseType = $LicenseType
			Write-Output ""
			Write-Output " Updating VMSS : ['$($VMSSName)'] with License :['$($LicenseType)'] Started"
			Update-AzureRmVmss -ResourceGroupName $AzureResourceGroup -VMScaleSetName $VMSSName -VirtualMachineScaleSet $vmss -Verbose:$false
			Write-Output " Updating VMSS : ['$($VMSSName)'] with License :['$($LicenseType)'] Completed"
		}
    }
	catch
	{
		Write-Output $_.Exception
		throw "Exception while applying VMSS License"
	}
}

Function Update-VMLicense
{
    Param(
		[Parameter(Mandatory=$true)][String]$AzureResourceGroup,
		[Parameter(Mandatory=$false)][String]$VMName,
		[Parameter(Mandatory=$true)][String]$LicenseType
    )
	try
	{
		if(!$VMName)
		{
			Write-Output " Updating VM in '$($AzureResourceGroup)' resource group"
			foreach ($VMName in (Get-AzureRmVm -ResourceGroupName $AzureResourceGroup).Name)
			{
				$vm = Get-AzureRmVm -ResourceGroupName $AzureResourceGroup -Name $VMName
				$vm.LicenseType = $LicenseType
				Write-Output ""
				Write-Output " Updating VM : ['$($VMName)'] with License : ['$($LicenseType)'] Started"
				Update-AzureRmVm -ResourceGroupName $AzureResourceGroup -VM $vm -Verbose:$false
				Write-Output " Updating VMSS : ['$($VMName)'] with License : ['$($LicenseType)'] Completed"
			}
		}
		else
		{
			$vm = Get-AzureRmVm -ResourceGroupName $AzureResourceGroup -Name $VMName
			$vm.LicenseType = $LicenseType
			Write-Output ""
			Write-Output " Updating VM : ['$($VMName)'] with License : ['$($LicenseType)'] Started"
			Update-AzureRmVm -ResourceGroupName $AzureResourceGroup -VM $vm -Verbose:$false
			Write-Output " Updating VMSS : ['$($VMName)'] with License : ['$($LicenseType)'] Completed"
		}
	}
	catch
	{
		Write-Output $_.Exception
		throw "Exception while applying VM License"
	}
}

Function AHUBLicensing
{
Param
(   
    [Parameter(Mandatory=$true)][String]$AzureSubscriptionName,
    [Parameter(Mandatory=$true)][String]$AzureResourceGroup,
    [Parameter(Mandatory=$false)][ValidateSet("VM","VMSS","VM,VMSS")][String]$Resource="VMSS",
	[Parameter(Mandatory=$false)][ValidateSet("Windows_Server","None")][String]$LicenseType="Windows_Server",
    [Parameter(Mandatory=$false)][String]$VMSSName="",
	[Parameter(Mandatory=$false)][String]$VMName=""
)
	try
	{
		Login-AzureRmAccount
		Select-AzureRmSubscription -SubscriptionName $AzureSubscriptionName
       
		Switch($Resource)
		{
			{($_ -eq "VMSS")}
			{
				Update-VMSSLicense -AzureResourceGroup $AzureResourceGroup -LicenseType $LicenseType -VMSSName $VMSSName
			}
			{($_ -eq "VM")}
			{
				Update-VMLicense -AzureResourceGroup $AzureResourceGroup -LicenseType $LicenseType -VMName $VMName
			}
			{($_ -eq "VM,VMSS")}
			{
				Update-VMSSLicense -AzureResourceGroup $AzureResourceGroup -LicenseType $LicenseType
				Update-VMLicense -AzureResourceGroup $AzureResourceGroup -LicenseType $LicenseType
			}
		}
	}
	catch
	{
		Write-Output $_.Exception
		throw "Exception while applying VM/VMSS License"
	}
}
AHUBLicensing -AzureSubscriptionName $AzureSubscriptionName -AzureResourceGroup $AzureResourceGroup -Resource $Resource -VMSSName $VMSSName -VMName $VMName -LicenseType $LicenseType -Verbose
