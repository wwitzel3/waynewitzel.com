---
categories: ["brainstorm", "sourcecontrol"]
date: 2008/10/11 18:57:22
guid: http://pieceofpy.com/?p=174
permalink: http://pieceofpy.com/2008/10/11/blog-themes-and-scm/
tags: brainstorm, sourcecontrol
title: Blog themes and SCM.
---
We have a new theme? You like? If not, blame commenter rholmes, it is his fault. Seriously though. In a previous post he brought up a very good point, the site looked like hell if you were browsing with images off. Well this new theme looks better with images off and overall it isn't too horribly bad. So, if you don't like it, suggest one, just make sure it looks good with images turned off.

Now to the SCM part. After about a week of playing with <a href="https://github.com/">Github</a> and <a href="http://lighthouseapp.com/">Lighthouse</a>, I found them both to be great products. They integrated well with each other and the tools for working with Git are available under every platform. If I didn't already have my own server and experience deploying <a href="http://trac.edgewall.org/">Trac</a> and <a href="http://www.selenic.com/mercurial/wiki/">Mercurial</a> I would use both these services without question. That being said, though I have enjoyed my time working with those tools, I've migrated my Github source and Lighthouse tickets over to a newly installed Trac 0.11, full circle.

End result. If you like tinkering. If you like managing your own installations or you have some customization/integration you would like to do, use Trac and Mercurial, otherwise use Github and one of the great ticket systems it integrates with; I enjoyed Lighthouse.

For fun, here is the circle of ticketing and scm life I've gone through over the last 6 years or so.
<ul>
	<li>cvs and PHP Ticket</li>
	<li>svn and home grown Python tickets</li>
	<li>svn and Trac</li>
	<li>Github and Lighthouse</li>
	<li>mercurial and Trac</li>
</ul>

Have to wonder what is next. A lot of people at work have been asking me why Github or mercurial? Why Wayne? True, that most of the time I am using the repositories for me, myself, and I (De La Soul), but the benefits extend just beyond handling version control for an arbitrary number of developers and clean merges. I'll do a write up soon.

All the sourcecode for this site is now located at: http://trac.pieceopfy.com/pieceofpy
I'll be updating all the old links through the other posts to reflect this. Fun.
