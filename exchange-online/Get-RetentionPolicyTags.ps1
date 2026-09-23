<#
.SYNOPSIS
    Displays retention tags associated with an Exchange Online
    retention policy.

.PARAMETER PolicyName
    Name of the retention policy.

.EXAMPLE
    .\Get-RetentionPolicyTags.ps1 -PolicyName "Default MRM Policy"

.NOTES
    Sanitized for public portfolio use.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$PolicyName
)

try {
    $policy = Get-RetentionPolicy -Identity $PolicyName -ErrorAction Stop

    foreach ($tag in $policy.RetentionPolicyTagLinks) {
        Get-RetentionPolicyTag -Identity $tag
    }
}
catch {
    Write-Error "Unable to retrieve retention policy tags. $($_.Exception.Message)"
}
