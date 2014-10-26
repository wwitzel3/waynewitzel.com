---
categories: ["python"]
date: 2008/10/02 13:24:34
guid: http://pieceofpy.com:81/?p=40
permalink: http://pieceofpy.com/2008/10/02/python-26-released/
tags: python
title: Python 2.6 Released
---
Python 2.6 was release yesterday. I've had a chance to run most of my code through this latest version and haven't run in to any issues. Looking over the features list I did notice a couple things you might be interested to know.
<ul>
	<li>json module added to standard library</li>
	<li>multiprocessing module was also added</li>
	<li>with keyword - cleans up some of those try/finally blocks</li>
	<li>as keyword - more important than people realize</li>
	<li>print as a method (future imports, standard in 3.0)</li>
	<li>user defined maps can be used with ** for passing in keyword args</li>
</ul>
All this and more can be found on the <a href="http://docs.python.org/whatsnew/2.6.html">What's New in Python 2.6</a> page. But if you're too lazy to read that, at least take the time to look at this example of using as, this was a much needed new keyword in Python and really cleans up code.

I've seen the following a lot, as mentioned on the python.org site. People think this is catching either KeyError or ValueError but they are wrong. It is only catching KeyError and storing that exception object in the ValueError variable.

[sourcecode language='python']
try:
    print my_dict['nokey']
except KeyError, ValueError:
    # handle the exception(s)
[/sourcecode]

Those exceptions should be in a tuple, then a comma for the variable to store the exception object in. The new method uses the as keyword and removes that ambiguous comma and makes for a much cleaner exception block when reading.

[sourcecode language='python']
try:
    print my_dict['nokey']
except (KeyError, ValueError) as e:
    print e
[/sourcecode]
