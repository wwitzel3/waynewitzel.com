---
categories: ["pylons", "sqlalchemy"]
date: 2010/01/21 07:22:42
guid: http://pieceofpy.com/?p=329
permalink: http://pieceofpy.com/2010/01/21/paster-shell-do-people-know-about-it/
tags: ''
title: paster shell - do people know about it?
---
Today I was having a chat today about Pylons vs. Django and for the most part it was pretty diplomatic. We got to talking about the Admin interface the Django has. Which you don't have to do any extra boiler plate for, it is just there for you. With Pylons you have to use something like FormAlchemy or use Turbogears to get a similar style admin interface for your models and data.

Since we were sitting at a computer, I went ahead brought up a quick project and did a little demo of the paster shell. Sure, it involves typing and it isn't as pretty or "fast" as an admin panel, but he didn't even know it existed. One of the common things he mentioned was, "if I want to change the menus that are dynamically defined" or "if a username needs to be changed" .. and the application itself doesn't have a custom admin panel, with Pylons he had to do raw SQL.

<pre>
$paster shell pylons_config.ini

All objects from demo.lib.base are available
Additional Objects:
   mapper     -  Routes mapper object
   wsgiapp    -  This project's WSGI App instance
   app        -  paste.fixture wrapped around wsgiapp

&gt;&gt;&gt; error_user = meta.Session.query(model.User).filter_by(username='wwitzel 3').one()
&gt;&gt;&gt; # nice thing about this, is you also will get exceptions throw if more than one record exists
&gt;&gt;&gt; error_user.username
u'wwitzel 3'
&gt;&gt;&gt; error_user.username = 'wwitzel3'
&gt;&gt;&gt; meta.Session.commit()
&gt;&gt;&gt; menu_typo = meta.Session.query(model.Menu).filter_by(id=1).one()
&gt;&gt;&gt; menu_typo.value
u'Abuot'
&gt;&gt;&gt; menu_typo.value = 'About'
&gt;&gt;&gt; meta.Session.commit()
</pre>

So that is a very simple example of how one would use the paster shell to update some bad data in the database while ensuring integrity of your custom model and extension code. After I showed this to my friend he wasn't as concerned about the lack of a web interface for administration within Pylons.
