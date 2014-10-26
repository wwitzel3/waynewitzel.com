---
categories: ["python", "community"]
tags: ["python", "community"]
date: 2008/12/04 20:26:32
guid: http://pieceofpy.com/?p=218
permalink: http://pieceofpy.com/2008/12/04/python-30-final-release/
title: Python 3.0 (final) release.
---
As I am sure most of you have heard <a href="http://www.python.org/download/releases/3.0/">Python 3.0 (final)</a> has been released. For me, this means some nights getting some continuing development projects updated for the language changes and freezing some projects in maintence mode with their own copy of Python 2.6 (or in some cases 2.4).

Some highlights
<ul>
	<li>print is now a function: print("5x5", "is", 5*5, sep=" ")</li>
	<li>annotations for methods (I create a lot of libraries, so this is great!)</li>
	<li>extended unpacking: x, y , *z = [1,2,3,4,5] now x is 1, y is 2, and z is 3-5</li>
	<li>&lt;&gt; removed, use != (personal favorite cause I hate &lt;&gt;)</li>
	<li>no longer can you from import * inside functions</li>
</ul>
See the whole list here: <a href="http://docs.python.org/3.0/whatsnew/3.0.html">http://docs.python.org/3.0/whatsnew/3.0.html</a>
