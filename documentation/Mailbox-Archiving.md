# Mailbox Archiving, Auto-Expanding Archive & Retention Policy Cleanup

## Purpose

Document the administrative process used to resolve mailbox storage issues 
across multiple mailboxes — enabling archiving, verifying it was actually 
running, and cleaning up overlapping retention policies that were 
preventing older mail from moving out of the primary mailbox as expected.

## Problem

Multiple users reported "mailbox almost full" warning pop-ups in Outlook. 
This is a recurring issue rather than a one-off: it has come up for several 
different mailboxes over time.

## Investigation & Process

For each affected mailbox:

1. **Checked mailbox statistics** — reviewed primary mailbox size, item 
   count, and quota against the storage warning threshold to confirm the 
   mailbox was actually approaching its limit.
2. **Checked archive status** — verified whether an archive mailbox already 
   existed and was enabled. In several cases, archiving had not yet been 
   enabled at all.
3. **Enabled the archive mailbox** where it wasn't already active.
4. **Enabled/verified auto-expanding archive**, which allows the archive to 
   grow automatically as needed rather than hitting its own limit later — 
   treated as a distinct step from simply enabling the initial archive.
5. **Reviewed the retention policy** applied to the mailbox. Found that some 
   mailboxes had overlapping or conflicting retention policies/tags applied, 
   which was affecting whether the Managed Folder Assistant correctly moved 
   eligible items into the archive.
6. **Resolved the overlapping policy conflicts** so a single, correct 
   retention policy applied to the mailbox.
7. **Monitored the mailbox for approximately 48 hours** after making 
   changes, then re-checked mailbox statistics to confirm items were 
   actually moving into the archive as expected — retention/archive 
   processing isn't instantaneous, so verifying after the fact mattered 
   more than assuming the change worked immediately.

## Key Concepts Applied

- **Archive mailbox vs. auto-expanding archive** — these are two separate 
  settings. Enabling an archive does not automatically mean it can grow 
  indefinitely; auto-expanding archive has to be separately enabled/verified.
- **Retention policies vs. retention tags** — a mailbox can end up with 
  more than one applicable policy/tag, and overlapping rules can prevent 
  expected behavior (e.g., mail not moving to archive on the expected 
  schedule).
- **Managed Folder Assistant (MFA)** — the background process responsible 
  for applying retention/archive policy actions. Processing runs on its own 
  schedule, so results should be checked after a delay rather than expected 
  instantly.

## Outcome

Mailboxes across multiple users were successfully moved off local storage 
warnings by enabling archiving, correcting retention policy conflicts, and 
confirming — via a follow-up check after ~48 hours — that mail was actually 
being processed into the archive as intended.

## Security Considerations

This process required Exchange Online administrative permissions 
sufficient to view and modify mailbox archive/retention settings. No 
mailbox content, user identity, or organization-specific policy names are 
included in this write-up.

> **Note:** This document has been sanitized for public portfolio use. 
> No company names, usernames, mailbox sizes, or tenant-specific details 
> are included.
