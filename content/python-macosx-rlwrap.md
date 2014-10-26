---
categories: ["tools", "python"]
date: 2010/04/20 08:22:57
guid: http://pieceofpy.com/?p=367
permalink: http://pieceofpy.com/2010/04/20/mac-os-x-custom-python-build-and-rlwrap/
tags: python, macosx, 64bit
title: Mac OS X custom Python build and rlwrap
---
I had built my Python interpreter from source because I wanted a 64bit compile to use with boost-python based generic algorithm. So for the last couple months I have not had readline support, which means no arrow support in the console. Also means neat shortcut's like _ would work for assigning the last result of an expression.

I finally got annoyed enough today to fix it. After a ton of failed attempts and trying to rebuild it with readline support. I found a post in the Ruby world where someone has having similar issues. Their solution was rlwrap. Having homebrew installed, I figured I'd give that a try.

<code>
wwitzel:~ brew install rlwrap
wwitzel:~ alias python='rlwrap python'
</code>

And presto, everything functioned as it should. I added the alias to my .bash_profile and made this blog post for when I forget about this in the future. Hope this helps someone else who might be wrestling with the same issue.
