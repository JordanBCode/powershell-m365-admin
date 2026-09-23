<#
.SYNOPSIS
    Retrieves primary and archive mailbox statistics.

.DESCRIPTION
    Reports mailbox and archive sizes and item counts for an Exchange
    Online mailbox.

.PARAMETER UserPrincipalName
    User principal name of the mailbox.

.EXAMPLE
    .\Get-MailboxArchiveStatistics.ps1 -UserPrincipalName "user@example.com"

.NOTES
    Sanitized for public portfolio use.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$UserPrincipalName
)

try {
    $primary = Get-EXOMailboxStatistics -Identity $UserPrincipalName -ErrorAction Stop
    $archive = Get-EXOMailboxStatistics -Identity $UserPrincipalName -Archive -ErrorAction SilentlyContinue

    [PSCustomObject]@{
        UserPrincipalName = $UserPrincipalName
        PrimarySize       = $primary.TotalItemSize
        PrimaryItems      = $primary.ItemCount
        ArchiveSize       = $archive.TotalItemSize
        ArchiveItems      = $archive.ItemCount
    }
}
catch {
    Write-Error "Unable to retrieve mailbox statistics. $($_.Exception.Message)"
}
