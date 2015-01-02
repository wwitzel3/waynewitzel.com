+++
Categories = ["email", "linux"]
Description = ""
Tags = ["email", "linux"]
date = "2015-01-02T13:30:00-04:00"
title = "Gmail to fastmail. Email backups"

+++

Recently I moved all of my personal and professional email off of Gmail. There were many reasons for moving off of Gmail.
I will avoid ranting here and just focus on the solution.

## Enter fastmail.fm

Enter [Fastmail.fm](http://fastmail.fm). Highly recommended, reasonably priced, and provided the main features I was
looking for.

 * Allow a custom domain name.
 * Provide a family/multi-account plan.
 * CalDav sync/sharing.
 * Chat/XMMP support.

Signup was quick and easy, they even offer a free trail. I followed all of their documentation/guides
for setting up my own domain. It was very easy to get everything configured using my existing Route 53 DNS.
Their import process from Gmail worked very well. I was able to have my entire Gmail account
imported (25,000 messages, 2GB) in about 4 hours. You will need to [setup Gmail for IMAP](https://support.google.com/mail/troubleshooter/1668960#ts=1665018) before you can
use the importer.

Once my messages were all imported, I setup Gmail to forward all mail to my new email account. I made a filter
in Fastmail that places all emails sent To my Gmail address in to a specific folder. This will allow me to easily
find and update sites and contacts that are still sending to my old Gmail address.

## Going mobile

I use an Android Nexus 5. It has wonderful email and chat integration for Gmail/Hangouts. Not very useful for me now.
After doing some research and testing of different applications I found [Blue Mail](http://www.bluemailapp.com/). This is a wonderful email
app for Android, in fact, I highly recommend it even if you are still using Gmail. You will want to adjust the folder
mappings and the number of days Blue Mail downloads by default.

For chat I using the [Xabber](http://www.xabber.org/) app. It works well with the XMMP server on Fastmail and also connects
to my other messaging services like Facebook.

## Backups

Part of the motivation for leaving Gmail was not having to worry about being denied access to my emails. Granted
I didn''t have to leave Gmail to fix this problem, but the process of leaving gave me the motivation needed
to find a good solution.

The solution I ended up going with is an hourly cron job. The job runs on my local HTPC which is running Ubuntu server.
The job itself is pretty straight forward. It runs an program called imapsync. This syncs my Fastmail IMAP with my
local Dovecot imap server. Dovecot is setup with my local user and stores messages in /home/user/Maildir. I''ve
made my users Maildir folder a git repository. After each run of imapsync, I perform a git add -A and a git commit.
Then I push the changes up to a couple different private remotes, one local backed by RAID5. The Maildir itself also has a dropbox sync.

Here is a copy of the script: [mailsync.sh](https://gist.github.com/wwitzel3/f74c4394bb7254ea5b33)

## Not looking back

I''ve been using this setup for about 3-months now and I have to say I am very happy. The peace of mind knowing that I can easily
change my mail provider without too much trouble and still have complete access to all my mail, even if the provider does not offer
the ability to export messages is very nice.

