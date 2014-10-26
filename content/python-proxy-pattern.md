---
categories: ["python", "community", "patterns"]
date: 2008/11/03 17:23:35
guid: http://pieceofpy.com/?p=203
permalink: http://pieceofpy.com/2008/11/03/blog-a-day-or-something-proxy-pattern/
tags: ["python", "patterns", "community"]
title: Blog a day or something... Proxy Pattern!
---
Been reading around and I guess November is the official blog entry a day writers month or something. I'll make a go again. In October, I tried the one post a day run for my blog. I did well, but fell short in the end. Though I've already missed the first two days in November, I'll call that the margin of error.

Oh and I believe the posts should have some meat to them. Not just another "Hey look, a post, I win November." Though as a last resort, I am not above that.

So for lack of anything better to write about, here is an oldie but goodie. A Python implementation of the proxy pattern (<a href="http://en.wikipedia.org/wiki/Lazy_loading#Virtual_proxy">virtual proxy</a>) with a real worldish feel to it.

First we define our ABC and subclass it for our needs.
<pre class="brush: py">
class File(object):
    def load(self):
        pass
        
class RealFile(File):
    def __init__(self, name):
        self.name = name
        self.load()

        def load(self):
        print "Loading %s..." % (self.name)
    def process1(self):
        print "[phase1] Processing %s..." % (self.name)
    def process2(self):
        print "[phase2] Processing %s..." % (self.name)
</pre>

Now, we can subclass File for our proxy. Now I know what you are saying. You don't need the extra levels of abstraction because Python doesn't have the levels of type sensitivity of other languages. Could you just implement this in the first RealFile subclass? Yes, but that isn't the point of this. The verbosity helps define the example and keeps this implementation language independent (mostly).

<pre class="brush: py">
class ProxyFile(File):
    def __init__(self, name):
        self.name = name
        self.file = None
        
    def process1(self):
        if not self.file:
            self.file = RealFile(self.name)
        self.file.process1()

    def process2(self):
        if not self.file:
            self.file = RealFile(self.name)
        self.file.process2()
</pre>

So you can see, this hides away the details of loading the file. Allows the user to call process1 / process2 as the business logic determines and preforms lazy loading. The Proxy pattern is very powerful when combined with other patterns. Like <a href="http://en.wikipedia.org/wiki/Null_Object_pattern">Null Object</a> and Lazy loading.

<pre class="brush: py">
def main():
    f1 = ProxyFile("bigdb01.csv")
    f2 = ProxyFile("bigdb02.csv")
    f3 = ProxyFile("bigdb03.csv")
    
    f1.process1()
    # some busines logic
    f1.process2()
    # more BL
    f2.process2()
    # more BL
    f2.process1()
    # Hey, we found what we needed, skipped f3
    #f3.process()
    
if __name__ == '__main__':
    main()
</pre>

You can view full source at: <a href="http://trac.pieceofpy.com/pieceofpy/browser/patterns/proxy.py">http://trac.pieceofpy.com/pieceofpy/browser/patterns/proxy.py</a>
