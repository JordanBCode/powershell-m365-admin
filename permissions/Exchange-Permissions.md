# Exchange Mailbox Permissions Investigation

## Purpose

Document the process used to configure and verify delegated mailbox 
access in Exchange Online — specifically Send As permissions — for a 
user who needed to send email as another mailbox owner.

## Problem

An executive assistant needed the ability to respond to email on behalf 
of an executive she supports, since he is occasionally unavailable to 
respond himself. The recipient needed to see the message as coming 
directly from the executive, not as a visibly delegated message.

## Key Concept: Send As vs. Send on Behalf

These are two distinct Exchange permissions that are easy to confuse:

- **Send As** — the message appears to the recipient as if it came 
  directly from the mailbox owner. There is no visible indication that 
  someone else sent it.
- **Send on Behalf** — the message shows as *"[Delegate] on behalf of 
  [Mailbox Owner]"*, making the delegation visible to the recipient.

Choosing the correct one matters: granting the wrong permission either 
exposes delegation that should stay invisible, or hides delegation that 
should be disclosed, depending on the business need.

## Process

1. **Confirmed the actual requirement** — the assistant needed to send 
   messages that appeared to come directly from the executive, which 
   meant Send As was the correct permission rather than Send on Behalf.
2. **Granted Send As permission** on the executive's mailbox to the 
   assistant's account via Exchange Online PowerShell.
3. **Verified the
