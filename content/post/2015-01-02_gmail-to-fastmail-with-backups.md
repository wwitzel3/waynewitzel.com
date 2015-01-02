+++
Categories = ["email", "linux"]
Description = ""
Tags = ["email", "linux"]
date = "2015-01-02T13:30:00-04:00"
title = "Gmail to fastmail. Email backups"

+++

Recently I moved all of my personal and professional email off of Gmail. There were many reasons for moving off of Gmail.
I will avoid ranting here, but you can read plenty about why you might want to move off Gmail here, here, and here.

## Enter fastmail.fm

Enter (Fastmail.fm)[http://fastmail.fm). Highly recommended, reasonably priced, and provided the main features I was
looking for.

 * Allow a custom domain name.
 * Provide a family/multi-account plan.
 * CalDav sync/sharing.
 * Chat/XMMP support.

Signup was quick and easy, they even offer a free trail. I followed all of their documentation/guides
for setting up my own domain. It was very easy to get everything configured using my existing Route 53 DNS.
Their import process from Gmail worked very well. I was able to have my entire Gmail account
imported (25,000 messages, 2GB) in about 4 hours. You will need to (setup Gmail for IMAP)[] before you can
use the importer.

Once my messages were all imported, I setup Gmail to forward all mail to my new email account. I made a filter
in Fastmail that places all emails sent To my Gmail address in to a specific folder. This will allow me to easily
find and update sites and contacts that are still sending to my old Gmail address.

## Going mobile

I use an Android Nexus 5. It has wonderful email and chat integration for Gmail. Not very useful for me now.
After doing some research and testing of different applications I found (Blue Mail)[]. This is a wonderful email
app for Android, in fact, I highly recommend it even if you are still using Gmail. For chat I am using the
(Xabber)[] app. It works well with the XMMP server on Fastmail and also connects to my other messaging services
like Facebook and my "old" Gmail account.

## Backups

Part of the motivation for leaving Gmail was not having to worry about being denied access to my emails. Granted
I didn''t have to leave Gmail to fix this problem, but the process of leaving gave me the motivation needed
to find a good solution.

The solution I ended up going with is an hourly cron job. The job runs on my local HTPC which is running Ubuntu server.
The job itself is pretty straight forward. It runs an program called imapsync. This syncs my Fastmail IMAP with my
local Dovecot imap server. Dovecot is setup with my local user and stores messages in /home/user/Maildir. I''ve
made my users Maildir folder a git repository. After each run of imapsync, I perform a git add -A and a git commit.
Then I push the changes up to a couple different private remotes, one local backed by RAID5 and the other a private
repo hosting on bitbucket. The Maildir itself also has a dropbox sync.

## Not looking back

