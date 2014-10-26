---
categories: ["pylons", "sqlalchemy"]
date: 2009/08/17 16:32:26
guid: http://pieceofpy.com/?p=316
permalink: http://pieceofpy.com/2009/08/17/sqlalchemy-and-json-w-pylons-best-practices/
tags: sqlalchemy pylons json
title: SQLalchemy and JSON w/ Pylons - Best Practices
---
I asked the question I Stackoverflow and maybe it was too generic for the site, since it just got trolled with "Google keyword" by some d-bag. So I deleted it and figured I'd throw it up on my blog a see about getting some feedback from the people who read this pile about. The reason I ask this is mainly because I am preparing to do some updated screencasts for Pylons.

I've seen multiple ways referenced in official docs and I have done it a few different ways myself. I am using Pylons and I am curious what the best practices are for this common scenario?

I have used something similar to this for auto-magically making the conversion happen.
<pre class="brush: py">
# The auto-magic version
# I pulled this off a blog, forget the source.
def _sa_to_dict(obj):
    for item in obj.__dict__.items():
        if item[0][0] is '_':
            continue
        if isinstance(item[1], str):
            yield [item[0], item[1].decode()]
        else:
            yield item

def json(obj):
    if isinstance(obj, list):
        return dumps(map(dict, map(_sa_to_dict, obj)))
    else:
        return dumps(dict(_sa_to_dict(obj)))

# here is the controller
@jsonify
def index(self, format='html'):
    templates = Session.query(Template).all()
    if format == 'json':
        return json(templates)
</pre>

I have also done the version where you use the jsonify decorator and build your dictionary manually, something like this, which is ok if I need to define some custom behavior for my JSON, but as the default behavior seems excessive.

<pre class="brush: py">
@jsonify
def index(self, format='html'):
    if format == 'json':
        q = Session.query
        templates = [{'id': t.id,
                      'title': t.title,
                      'body': t.body} for t in q(Template)]
        return templates
</pre>

I've also created an inherited SA class which defines a json method and have used that on all my objects to convert them to JSON. Similar to the the fedora extensions.

Maybe I missed some obviously library out there or some obvious helper in the Pylons packages, but I feel like this is a very common task being done a dozen different ways between docs, source, and my own personal projects. Curious what others are doing / using.
