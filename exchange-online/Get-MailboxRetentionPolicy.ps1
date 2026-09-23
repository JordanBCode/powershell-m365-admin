<#
.SYNOPSIS
    Retrieves the retention policy assigned to an Exchange Online mailbox.

.PARAMETER UserPrincipalName
    User principal name of the mailbox.

.EXAMPLE
    .\Get-MailboxRetentionPolicy.ps1 -UserPrincipalName "user@example.com"

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

    [PSCustomObject]@{
        DisplayName       = $mailbox.DisplayName
        UserPrincipalName = $mailbox.UserPrincipalName
        RetentionPolicy   = $mailbox.RetentionPolicy
        ArchiveStatus     = $mailbox.ArchiveStatus
        ArchiveState      = $mailbox.ArchiveState
    }
}
catch {
    Write-Error "Unable to retrieve retention policy information. $($_.Exception.Message)"
}
