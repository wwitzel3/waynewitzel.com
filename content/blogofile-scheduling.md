---
categories: ["python"]
date: 2011/08/28 18:30:00
tags: python, blogofile
title: Scheduling Posts with Blogofile
---
<p>
    I wanted to be able to schedule posts with blogofile and this was the quickest way I could think of to do it. If someone knows of a better way, than please comment cause I would love to read about.
</p>

<p>
    My change is pretty simple, if the date in the YAML header is > than now, throw a PostProcessing exception and continue on with the next post. I added a cronjob that runs blogofile build every hour, so this solution sucks for blogs that take a long time to build or if you want precision scheduling, but my site builds fast and I am ok with an hour delay.

<br/>

<pre class="brush: diff">
diff -r e370cb5a903f blog/_controllers/blog/post.py
--- a/blog/_controllers/blog/post.py	Tue Aug 23 23:16:37 2011 -0400
+++ b/blog/_controllers/blog/post.py	Sun Aug 28 19:03:28 2011 -0400
@@ -70,7 +70,14 @@
     def __str__(self):
         return repr(self.value)
 
+class PostProcessException(Exception):
 
+    def __init__(self, value):
+        self.value = value
+
+    def __str__(self):
+        return repr(self.value)
+                
 class Post(object):
     """
     Class to describe a blog post and associated metadata
@@ -179,7 +186,11 @@
             self.slug = slug
 
         if not self.date:
-            self.date = datetime.datetime.now(pytz.timezone(self.__timezone))
+            self.date       = datetime.datetime.now(pytz.timezone(self.__timezone))
+        else:
+            if self.date > datetime.datetime.now(pytz.timezone(self.__timezone)):
+                raise PostProcessException('Post date is in the future.')
+
         if not self.updated:
             self.updated = self.date
 
@@ -367,7 +378,7 @@
             raise
         try:
             p = Post(src, filename=post_fn)
-        except PostParseException as e:
+        except (PostParseException,PostProcessException) as e:
             logger.warning(u"{0} : Skipping this post.".format(e.value))
             continue
         #Exclude some posts
</pre>
</p>
