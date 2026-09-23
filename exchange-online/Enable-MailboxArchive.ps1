<#
.SYNOPSIS
    Enables an Exchange Online archive for a mailbox.

.DESCRIPTION
    Checks the current archive state and enables the archive when one
    does not already exist.

.PARAMETER UserPrincipalName
    User principal name of the mailbox.

.EXAMPLE
    .\Enable-MailboxArchive.ps1 -UserPrincipalName "user@example.com"

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

    if ($mailbox.ArchiveStatus -eq "Active") {
        Write-Host "Archive is already active for $UserPrincipalName."
    }
    else {
        Enable-Mailbox -Identity $UserPrincipalName -Archive -ErrorAction Stop
        Write-Host "Archive enabled for $UserPrincipalName."
    }
}
catch {
    Write-Error "Unable to configure archive for $UserPrincipalName. $($_.Exception.Message)"
}
