---
categories: ["python"]
date: 2011/01/24 19:56:00
tags: python, snippets
title: Validate All Items in a Sequence
---

A co-worker was using all and complained that he couldn't use a lambda so that
the default call to bool() would be done over the return of the lambda which would
so some complex validation and return True or False.

I thought the obvious solution was to use map with all. Obviously you would replace
the lambda call to your own validation method if you had any advanced or complicated
checking to do. I think this solution works out pretty well.

<p>
<pre class="brush: py">
>>> all(map(lambda x: x>10, xrange(1,20)))
False
>>> all(map(lambda x: x>10, xrange(20,30)))
True
</pre>        
</p>

<h3>Update</h3>
My original post sucked, thanks to Peter Ward and Michael Foord for the feedback.
Here is a way to do the same thing using 
<a href="http://docs.python.org/reference/expressions.html#generator-expressions">generator expressions.</a>
<p>
<pre class="brush: py">
>>> all(x > 10 for x in xrange(1, 20))
False
>>> all(x > 10 for x in xrange(20, 30))
True
</pre>
</p>
