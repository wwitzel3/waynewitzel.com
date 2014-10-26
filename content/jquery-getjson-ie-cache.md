---
categories: ["jquery"]
date: 2009/08/13 17:55:55
guid: http://pieceofpy.com/?p=313
permalink: http://pieceofpy.com/2009/08/13/jquery-getjson-and-ie-cache/
tags: ["jquery"]
title: jQuery getJSON and IE cache
---
I am sure everyone else who lives in the world of jQuery knows this, so this is more here for my own future reference and avoiding and more wasting of time, but if you are going to us $.getJSON helper in jQuery, append a time stamp to it to prevent odd caching behavior in IE. See the example below.

<code>
$.getJSON("/story/story_id.php?_="+(new Date().getTime()), function(json) {
    $('#next_story_id').html('S' + json.next_story_id);
});
</code>

This might not be the best way to do it and really, this is good practice for all dynamic requests to avoid caching issues from the browser and the server. Chalk this up as a good learning experience that sucked 30 minutes of my life. I hate front end stuff.
