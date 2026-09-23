# Message Trace Investigation

## Purpose

Document the use of Exchange Online message trace to investigate email 
delivery issues — including tracking down an unexpected sender, confirming 
whether vendor emails were actually received, and identifying when a 
delivery problem was actually a quarantine issue rather than a trace/
routing issue.

## Case 1: Unexpected Sender Investigation

**Problem:** A user reported receiving emails from a sender that wasn't 
part of any distribution list or group they were aware of, raising the 
question of why they were receiving that mail at all.

**Investigation:** Used message trace to look at the delivery path for 
the messages in question — who they were actually addressed to, and how 
they arrived in the user's mailbox.

**Finding:** The messages were arriving via a **forwarding policy**, not 
because the user was on a distribution list. Once identified, this 
explained the unexpected mail and pointed to the forwarding rule as the 
actual source rather than a mailing list misconfiguration.

## Case 2: Vendor Delivery Verification

**Problem:** Needed to determine whether emails from specific vendors were 
actually being received, or whether they were being blocked or stopped 
somewhere in the mail flow.

**Investigation:** Used message trace with sender/recipient and date-range 
filtering to check whether the vendor's messages had entered the Exchange 
Online environment at all, and if so, what happened to them after that 
(delivered, blocked, or otherwise diverted).

**Outcome:** Message trace results distinguished between "never arrived" 
and "arrived but didn't reach the inbox," which determines whether the 
next step is contacting the vendor or investigating further inside the 
mail environment.

## Case 3: Message Trace + Quarantine

**Problem:** Some expected emails weren't reaching their intended 
recipients.

**Investigation:** Message trace showed the messages had entered the 
environment, which ruled out a delivery/routing failure — the next step 
was checking whether the messages had instead been sent to **quarantine**.

**Finding:** Confirmed via quarantine review that the missing emails were 
being caught there rather than lost in transit. This distinguished a 
security-filtering issue from a mail-flow/routing issue — two different 
problems that look similar from the user's side ("I didn't get the 
email") but require different fixes.

## Key Concept / Limitation

Message trace can investigate messages that pass through the 
organization's own Exchange Online environment — it does not provide 
visibility into arbitrary external mail systems simply because a sender 
or recipient address is known. It's a tool for confirming what happened 
*inside* the environment, not a universal email-tracking tool.

## Security Considerations

This work required Exchange Online administrative access to run message 
trace and review quarantine. No real sender/recipient addresses, vendor 
names, or user identities are included.

> **Note:** This document has been sanitized for public portfolio use. 
> No company names, email addresses, or tenant-specific details are 
> included.
