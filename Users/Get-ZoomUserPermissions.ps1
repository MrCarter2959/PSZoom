<#

.SYNOPSIS
Retrieve a user’s permissions.
.DESCRIPTION
Retrieve a user’s permissions.
.PARAMETER UserId
The user ID or email address.
.PARAMETER ApiKey
The Api Key.
.PARAMETER ApiSecret
The Api Secret.
.EXAMPLE
Get-ZoomUserPermissions jsmith@lawfirm.com
.OUTPUTS
A hastable with the Zoom API response.

#>

$Parent = Split-Path $PSScriptRoot -Parent
import-module "$Parent\ZoomModule.psm1"

function Get-ZoomUserPermissions {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $True, 
            Position = 0, 
            ValueFromPipeline = $True
        )]
        [Alias('Email', 'EmailAddress', 'Id')]
        [string]$UserId,

        [string]$ApiKey,

        [string]$ApiSecret
    )

    begin {
        #Get Zoom Api Credentials
        if (-not $ApiKey -or -not $ApiSecret) {
            $ApiCredentials = Get-ZoomApiCredentials
            $ApiKey = $ApiCredentials.ApiKey
            $ApiSecret = $ApiCredentials.ApiSecret
        }

        #Generate Header with JWT (JSON Web Token)
        $Headers = New-ZoomHeaders -ApiKey $ApiKey -ApiSecret $ApiSecret
    }

    process {
        $Request = [System.UriBuilder]"https://api.zoom.us/v2/users/$UserId/permissions"

        try {
            $Response = Invoke-RestMethod -Uri $Request.Uri -Headers $headers -Method GET
        } catch {
            Write-Error -Message "$($_.exception.message)" -ErrorId $_.exception.code -Category InvalidOperation
        }

        Write-Output $Response
    }
}