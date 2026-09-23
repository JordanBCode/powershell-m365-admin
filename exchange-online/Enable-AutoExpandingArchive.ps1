<#
.SYNOPSIS
    Enables auto-expanding archive for an Exchange Online mailbox.

.PARAMETER UserPrincipalName
    User principal name of the mailbox.

.EXAMPLE
    .\Enable-AutoExpandingArchive.ps1 -UserPrincipalName "user@example.com"

.NOTES
    Sanitized for public portfolio use.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$UserPrincipalName
)

try {
    $mailbox = Get-Mailbox -Identity $UserPrincipalName -ErrorAction Stop

    if ($mailbox.AutoExpandingArchiveEnabled) {
        Write-Host "Auto-expanding archive is already enabled for $UserPrincipalName."
    }
    else {
        Enable-Mailbox -Identity $UserPrincipalName -AutoExpandingArchive -ErrorAction Stop
        Write-Host "Auto-expanding archive enabled for $UserPrincipalName."
    }
}
catch {
    Write-Error "Unable to enable auto-expanding archive for $UserPrincipalName. $($_.Exception.Message)"
}
