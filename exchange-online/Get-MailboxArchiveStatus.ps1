<#
.SYNOPSIS
    Reports Exchange Online archive status for a mailbox.

.DESCRIPTION
    Retrieves archive-related configuration for the specified mailbox,
    including archive status and auto-expanding archive status.

.PARAMETER UserPrincipalName
    User principal name of the mailbox to inspect.

.EXAMPLE
    .\Get-MailboxArchiveStatus.ps1 -UserPrincipalName "user@example.com"

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
        DisplayName           = $mailbox.DisplayName
        UserPrincipalName     = $mailbox.UserPrincipalName
        ArchiveStatus         = $mailbox.ArchiveStatus
        ArchiveState           = $mailbox.ArchiveState
        AutoExpandingArchive  = $mailbox.AutoExpandingArchiveEnabled
        RetentionPolicy       = $mailbox.RetentionPolicy
    }
}
catch {
    Write-Error "Unable to retrieve mailbox information for $UserPrincipalName. $($_.Exception.Message)"
}
