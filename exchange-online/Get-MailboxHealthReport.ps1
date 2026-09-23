<#
.SYNOPSIS
    Generates a mailbox health and archive configuration report.

.DESCRIPTION
    Collects mailbox configuration, archive status, retention policy,
    auto-expanding archive status, and mailbox statistics into a single
    combined report - consolidating the individual checks performed in
    the other scripts in this folder.

.PARAMETER UserPrincipalName
    User principal name of the mailbox.

.EXAMPLE
    .\Get-MailboxHealthReport.ps1 -UserPrincipalName "user@example.com"

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
    $primaryStats = Get-EXOMailboxStatistics -Identity $UserPrincipalName -ErrorAction Stop
    $archiveStats = Get-EXOMailboxStatistics -Identity $UserPrincipalName -Archive -ErrorAction SilentlyContinue

    [PSCustomObject]@{
        DisplayName           = $mailbox.DisplayName
        UserPrincipalName     = $mailbox.UserPrincipalName
        RetentionPolicy       = $mailbox.RetentionPolicy
        ArchiveStatus         = $mailbox.ArchiveStatus
        ArchiveState          = $mailbox.ArchiveState
        AutoExpandingArchive  = $mailbox.AutoExpandingArchiveEnabled
        PrimaryMailboxSize    = $primaryStats.TotalItemSize
        PrimaryMailboxItems   = $primaryStats.ItemCount
        ArchiveMailboxSize    = $archiveStats.TotalItemSize
        ArchiveMailboxItems   = $archiveStats.ItemCount
    }
}
catch {
    Write-Error "Unable to generate mailbox health report. $($_.Exception.Message)"
}
