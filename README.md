# PoshARM

## What is this?
A Powershell module for Azure ARM templates. You can parse and create Azure ARM templates with this module.

## Cmdlets implemented
            
#### Add-ARMparameter**

> Add an ARM parameter to an ARM template.

#### Add-ARMresource**

> Add an ARM resource to an ARM template.
#### Add-ARMvariable**

> Add an ARM variable to an ARM template.
#### ConvertTo-Hash**

> Converts a PScustomobject to a hashtable
#### Get-ARMparameter**

> Get all parameters or a specific one by name.
#### Get-ARMparameterScript**

> Get the Powershell script that will recreate the parameteres in the ARM template
#### Get-ARMresourceList**

> Get a list of resource providers in Azure
#### Get-ARMresourceScript**

> Get the Powershell script that will recreate the resources in the ARM template
#### Get-ARMtemplate**

> Get the ARM template defined at the module level
#### Get-ARMtemplateScript**

> Get the Powershell script that will recreate the ARM template
#### Get-ARMvariable**

> Get all variable or a specific one by name.
#### Get-ARMvariableScript**

> Get the Powershell script that will recreate the variables in the ARM template
#### Import-ARMtemplate**

> Import an ARM template.
#### New-ARMparameter**

> Create a new ARM template parameter
#### New-ARMresource**

> Create a new ARM template resource
#### New-ARMTemplate**

> Create a new blank ARM template.

#### New-ARMvariable**

> Create a new ARM template variable
#### Out-HashString**

> Convert an hashtable or and OrderedDictionary to a string
#### Set-ARMmetadata**

> Creates a metadata.json file for your ARM template
#### Set-ARMparameter**

> Update an existing parameter in the ARM template
#### Set-ARMvariable**

> Update an existing variable in the ARM template
#### Update-ARMresourceList**

> This will update the allResources.json file that is used as input when creating a New-ARMresource



## Guide

You can find a guide on my blog at [PoshARM blog guide!](http://asaconsultant.blogspot.no/2017/01/something-completely-different-posharm.html).


## Status
Current status: Under development


## PowershellGallery
Published to PowershellGallery: Not yet, but very soon
