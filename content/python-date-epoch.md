---
categories: ["python"]
tags: ["python", "snippets"]
date: 2010/12/29 12:45:00
title: Response - convert date to epoch
permalink: /2010/12/29/response-convert-date-to-epoch
---
I ran across <a href="http://sandrotosi.blogspot.com/">Sandro Tosi</a>'s post about <a href="http://sandrotosi.blogspot.com/2010/12/convert-date-to-epoch.html">converting a date to epoch</a> and for what ever reason blogger wasn't letting me leave comments so I figured I'd toss this post up. I just had to do this very same thing in one of my projects.

<p>
<pre class="brush: py">
>>> import time, calendar
>>> ts = time.strptime('2010-12-01', '%Y-%m-%d')
>>> calendar.timegm(ts)
1291161600
>>> ts = time.strptime('1970-01-01', '%Y-%m-%d')
>>> calendar.timegm(ts)
0
</pre>
</p>

So there you have it. Thank you calendar module!

