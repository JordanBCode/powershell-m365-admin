# Microsoft 365 & Exchange PowerShell

A collection of PowerShell scripts and administrative workflows developed 
through hands-on Microsoft 365, Exchange Online, email investigation, 
mailbox management, permissions, and Windows endpoint administration.

## Contents

- [`exchange-online/`](./exchange-online/) — PowerShell scripts for 
  Exchange Online mailbox administration, archiving, retention, and 
  storage monitoring.
- [`email-investigation/`](./email-investigation/) — Documented workflows 
  for investigating message delivery, message trace results, and email 
  quarantine issues.
- [`permissions/`](./permissions/) — Documented workflow for investigating 
  Exchange mailbox permissions and delegated access (Send As).
- [`windows-endpoint/`](./windows-endpoint/) — PowerShell automation for 
  Windows application deployment and endpoint configuration.
- [`documentation/`](./documentation/) — Detailed write-ups explaining 
  the problems addressed, administrative process, and results.

## Why this repo exists

This repository documents practical PowerShell and Microsoft 365 
administrative work performed on the job. The scripts and write-ups focus 
on repeatable administrative tasks, troubleshooting, email investigation, 
mailbox management, and automation rather than hypothetical examples — 
each is documented to explain its purpose, how it works, and the 
administrative problem it was designed to solve.

## Skills Demonstrated

PowerShell scripting, Microsoft 365 administration, Exchange Online 
administration, mailbox archiving and retention, Exchange Online 
permissions, message trace investigation, email security troubleshooting, 
Windows endpoint automation, logging and error handling, administrative 
troubleshooting.

> **A note on script provenance (`exchange-online/`):** These scripts are 
> sanitized, reconstructed versions of PowerShell workflows I actually 
> performed on the job — following guided steps for each task and 
> personally verifying the results at every step (e.g., confirming 
> archive status changed, confirming retention policy conflicts were 
> resolved). They are not scripts I authored from scratch or saved as 
> standalone files at the time. I can walk through the reasoning and 
> outcome of each step in detail.
>
> Message trace and quarantine investigation were performed through the 
> Exchange Admin Center GUI rather than PowerShell, so those are 
> documented as workflows in `email-investigation/` rather than scripts.

> **A note on script provenance (`windows-endpoint/`):** I identified the 
> deployment need — standardizing app installs (Chrome, Zoom, Microsoft 
> 365, Adobe Acrobat Reader) across machines — and built this script 
> through iterative work with AI assistance: specifying requirements, 
> refining the logic across multiple versions, and deploying/testing each 
> version to confirm everything installed correctly. I can walk through 
> what each section does, why it's structured this way, and what changed 
> between versions based on real deployment results.

> **Note:** Scripts and documentation are sanitized for public use. 
> Company names, domains, usernames, email addresses, tenant-specific 
> information, credentials, and other identifying or confidential 
> information have been removed or replaced with generic examples.
