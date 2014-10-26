---
categories: ["deploy", "sourcecontrol", "personal"]
date: 2009/03/12 14:48:21
guid: http://pieceofpy.com/?p=238
permalink: http://pieceofpy.com/2009/03/12/i-didnt-want-those-changes-anyway/
tags: source control, hg, oops
title: I didn't want those changes anyway.
---
I use hg (<a href="http://www.selenic.com/mercurial/wiki/">Mercurial</a>) for version control. Since switching to hg I have adopted the following process. I also do this for my Git projects at work.
<ul>
	<li>I create a local branch to working.</li>
	<li>I setup my External Tools in Eclipse to run my test suite.</li>
	<li>The output of my test suite gets committed to my local branch.</li>
	<li>I squash the local branch messages when I merge in to master.</li>
	<li>I add some insightful commit message for my master commit. Like, I haz changes.</li>
</ul>
So yesterday, I roll up my sleeves and prepare to dive in to an older project that <a href="http://en.wikipedia.org/wiki/Code_smell">smells like rotten potatoes</a>. The plan of attack is to take this project and bring it up-to-date with Python 2.6, Pylons 0.9.7, and SQLalchemy 0.5.2 in the process of doing it, re-factor and extend where needed, of course letting the tests drive. I start my work and wand waving and 2-3 hours in I've removed about 200 lines of cruft and copy paste inheritance extended flexibility by further encapsulating some behavior using the Strategy pattern. I've got 47 tests (including functional doctests) passing and I'm green bar and happy with my time spent. So now time to merge this baby back in to master.

My test suite external tool performs the hg add . and I keep my .hgignore pretty up-to-date for Python projects, so I feel confident doing that. I open up the terminal to check out the change sets and start the merge and I notice I missed a binary format in my .hgignore. So I now have about 15 unwanted files staged for adding. Being lazy and knowing my last commit was when I just ran my test suite, I blindly run.

[sourcecode lang="bash"]
$ ^R hg revert <enter> <enter> (Ctrl-R, hg revert - shell previous command search)
$ hg revert -a --no-backup
# ...my work being destroyed because I was lazy and not paying attention
# whimpering
[/sourcecode]

It is at this point my day goes from great to awful. I face palm as I watch the uncommitted changes I've been making over the last 3 hours get reverted. As I mentioned, this project was older, in fact, it was started before the migration to hg and I never updated the External Tools runnable for this project in Eclipse to do the new hg add / commits. So every time I thought I was committing when I was running the tests, I was in fact not. Fortunate for me, I did have some buffers open and was able to recover the end result in about 45 minutes of hacking, but I did lose all of my change history which was very very disappointing (not to mention scary).

So if I had any advice after this it would be ensure your older projects are up-to-date with how you do things now and they follow your current development process before you start refactoring. I guess the oneliner could be; When refactoring a project start with the tool set first.
