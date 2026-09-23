<#
.SYNOPSIS
    Starts Managed Folder Assistant processing for a mailbox.

.DESCRIPTION
    Requests retention processing for the specified Exchange Online
    mailbox. Processing is not instantaneous - re-check mailbox
    statistics after some time has passed to confirm results.

.PARAMETER UserPrincipalName
    User principal name of the mailbox.

.EXAMPLE
    .\Start-MailboxManagedFolderAssistant.ps1 -UserPrincipalName "user@example.com"

.NOTES
    Sanitized for public portfolio use.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$UserPrincipalName
)

try {
    Start-ManagedFolderAssistant -Identity $UserPrincipalName -ErrorAction Stop
    Write-Host "Managed Folder Assistant processing requested for $UserPrincipalName."
}
catch {
    Write-Error "Unable to start Managed Folder Assistant processing. $($_.Exception.Message)"
}
