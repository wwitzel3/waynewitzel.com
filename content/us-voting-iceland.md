---
categories: ["python", "personal"]
date: 2008/11/04 20:20:13
guid: http://pieceofpy.com/?p=206
permalink: http://pieceofpy.com/2008/11/04/voting-and-the-land-of-ice-and-snow/
tags: ["python", "snippet", "iceland"]
title: Voting and the land of ice and snow.
---
Today is election day in the states. Lots of free coffee and donut offers floating around for those few people wearing their I voted sticker.

Tomorrow I head out for my trip to Iceland. From Florida to Iceland in the Fall, makes perfect sense right? It was an excuse for me to purchase some new warm wear and jogging shoes, have to keep up with the exercise routine even on vacation. I should be able to maintain the blog from there keeping the spirit of blog every day in November.

<strong>Snippet of Python</strong>
In an effort to always have something a little Python related in all my posts, here is how to use list comprehension to filter out no value items from a list.
[sourcecode language="python"]
foo = ["A", "", "C", None, "E"]
bar = [i for i in foo if i]
print bar
['A', 'C', 'E']
[/sourcecode]

