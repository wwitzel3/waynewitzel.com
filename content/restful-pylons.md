---
categories: ["python", "rest"]
date: 2008/09/25 17:06:23
guid: http://pieceofpy.com:81/?p=8
permalink: http://pieceofpy.com/2008/09/25/restful-pylons/
tags: ["python", "code", "rest"]
title: RESTful Pylons
---
In the process of creating a new web service for the purpose of allowing external applications to communicate with my site, I realized I was going against the grain and making things harder for myself than they had to be.

Pylons and Python make it so easy to just start pounding out code you can be half way through an implementation before you realize it is broke, or reinventing something that already exists, or just plain sucks.

So, I do a commit to my local repository, Ctrl+A and hit delete. Lets try this over. I take a step back and look at what we need to do.

We have a Kill object. This is a representation of a Ship a Pilot and another or many other Ship(s) and Pilot(s) who destroyed this ship and where and why the did it. That is the verbose text version of a kill. My remote service wants to perform CRUD operations on this model. I have all this implemented already, the controllers for my views do all of this .. so why not copy them and just give them some tweaks and expose these new methods under a poorly named controller? Great idea! .. Not so much.

So, the solution, create a new <a href="http://en.wikipedia.org/wiki/Representational_State_Transfer">REST</a> controller in Pylons. Pylons does all the heavy lifting for you with a simple command, the only thing you need to do is update your routing.py to include the new resource. You create the REST controller just like you would a normal, but using restcontroller instead of controller and adding and extra variable for the name of the resource. Usually a plural of your model.

<code># paster restcontroller kill kills
Creating wayne\qkb\controllers\kills.py
Creating wayne\qkb\tests\functional\test_kills.py
To create the appropriate RESTful mapping, add a map statement to your
config/routing.py file near the top like this:
map.resource('kill', 'kills')</code>

Ok, so what did that give us? Well, basically everthing we need. If you pop open kills.py in your controllers, you'll see it already has sketched out the methods you'll be implementing for your kills resource and also gives you a reminder to update your routing.py

From here, it is rather simple. Just implement the responses in each of the methods that your external application will need. Don't forget to change the formats from HTML if you aren't going to be sending back to a browser or HTML parser. Example of the index implementation. Which would be called using a GET to /kills under the default routing.
[sourcecode language="python"]
def index(self, format='xml'):
    """GET /kills: All items in the collection."""
    # url_for('kills')
    kill_q = meta.Session.query(model.Kill)
    c.kills = kill_q.all()
    return render('/derived/kills/list.xml')
[/sourcecode]

Following this pattern, I implement the rest of my resource methods and end up with a fully functional resource with in minutes. Not only was this faster to live than modifying the methods that were designed for handling posts from the view layer, it also creates a much cleaner exposure of the Kill model to external services. Heres the implementation of create, which is /kills with the POST method.

[sourcecode language="python"]
def create(self):
    """POST /kills: Create a new item."""
    # url_for('kills')
    try:
       params = model.forms.schema.KillSchema.\
                to_python(request.params)
       kill = model.Kill(**params)
       meta.Session.save(kill)
       meta.Session.commit()
       c.killid = kill.id
       return render('/derived/kill/create.xml')
    except formencode.Invalid, e:
       c.errors = e.errors_dict() or {}
       return render('/derived/kill/error.xml')
[/sourcecode]
