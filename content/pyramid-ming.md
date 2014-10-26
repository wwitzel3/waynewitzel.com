---
categories: ["python", "ming"]
date: 2012/01/10 09:00:00
permalink: http://pieceofpy.com/2012/01/10/working-with-pyramid-and-ming
tags: python, pyramid, ming
title: Working with Pyramid and Ming
---

As I've been working on [Community Cookbook](http://sf.net/p/stockpot) I have encountered some situations
using Ming that I am sure many other people have as well. Using Ming as my ODM and I have been
very happy with how it is going so I wanted to share with everyone the steps I have taken to integrate Ming into Pyramid. My goal was to make it feel just like you would except a data storage integration to feel. Simple, clean, and easy.

As part of creating this integration, I created my own scaffold to hook everything up. You can download and try the scaffold yourself from my [SourceForge repository](https://sourceforge.net/u/algorithms/wwitzel3-scaffolds). Below I will outline some of the key areas I had to configure. I highly reccomend you install and create a sample project with the scaffold when you follow along with this blog post.

First in the main __init__.py of the project, I had to setup some configuration. If you have created a new project using the scaffold this will be done for you. Here are the important snippets from root __init__.py

<pre class="brush: py">
# stockpot/__init__.py

from pyramid.events import NewRequest
import stockpot.models as M

def main(global_config, **settings):
    # ...
    config.begin()
    config.scan('stockpot.models')
    M.init_mongo(engine=(settings.get('mongo.url'), settings.get('mongo.database')))
    config.add_subscriber(close_mongo_db, NewRequest)
    # ...

def close_mongo_db(event):
    def close(request):
         M.DBSession.close_all()
    event.request.add_finished_callback(close)
</pre>

Now lets take a look at what you are getting from the models import (M). We use init mongo which does exactly what you think and then we use DBSession which I used as a name since it is familar to those who are coming from SQLalchemy. I will just show you the entire file.

<pre class="brush: py">
# stockpot/models/__init__.py

from ming import Session
from ming.datastore import DataStore
from ming.orm import ThreadLocalORMSession
from ming.orm import Mapper

session = Session
DBSession = ThreadLocalORMSession(session)

def init_mongo(engine):
    server, database = engine
    datastore = DataStore(server, database=database)
    session.bind = datastore
    Mapper.compile_all()

# Here we just ensure indexes on all our mappers at startup.
    for mapper in Mapper.all_mappers():
        session.ensure_indexes(mapper.collection)

# Flush changes and close all connections
    DBSession.flush()
    DBSession.close_all()

from .user import User
</pre>

Now I want to show you how I did the groupfinder and RequestWithAttribute. Since I imagine most of you looking to use Ming will probably have some type of user model. For the groupfinder and RequestWithAttributes the only special thing I had to do was add an extra step to convert the users id in to a proper bson.ObjectId

<pre class="brush: py">
from pyramid.decorator import reify
from pyramid.request import Request
from pyramid.security import unauthenticated_userid

import bson
import stockpot.models as M

def groupfinder(userid, request):
    userid = bson.ObjectId(userid)
    user = M.User.query.get(_id=userid)
    return [] if user else None

class RequestWithAttributes(Request):
    @reify
    def user(self):
        userid = unauthenticated_userid(self)
	userid = bson.ObjectId(userid)
	if userid:
	    return M.User.query.get(_id=userid)
	return None
</pre>

Finally here is what my mapped User model might look like. This is a sample taken from a real project with some sensitive elements replaced and/or removed. Use it as an example, but not as a good one.

<pre class="brush: py">
# stockpot/models/user.py

from hashlib import sha1
from datetime import datetime
from string import ascii_letters, digits
from random import choice

from ming import schema as S
from ming.orm import FieldProperty
from ming.orm.declarative import MappedClass

from pyramid.httpexceptions import HTTPForbidden

from stockpot.models import DBSession

# If you change this AFTER a user signed up they will not be able to
# login until they perform a password reset.
SALT = 'supersecretsalt'
CHARS = ascii_letters + digits
MAX_TRIES = 100

class User(MappedClass):
    class __mongometa__:
        session = DBSession
        name = 'users'
        custom_indexes = [
                dict(fields=('email',), unique=True, sparse=False),
                dict(fields=('username',), unique=True, sparse=False),
                dict(fields=('identifier',), unique=True, sparse=False),
        ]

    # This should feel familar to anyone coming from SQLa
    _id = FieldProperty(S.ObjectId)
    username = FieldProperty(str)
    email = FieldProperty(str)
    password = FieldProperty(str, if_missing=S.Missing)
    signup_date = FieldProperty(datetime, if_missing=datetime.utcnow())

    # Simple init method
    def __init__(self, *args, **kwargs):
        self.signup_date = datetime.utcnow().replace(microsecond=0)
        self.username = kwargs.get('username')
        if kwargs.get('password'):
            self.password = User.generate_password(kwargs.get('password'),
                    str(self.signup_date))
        self.email = kwargs.get('email', '{0}@example.com'.format(self.username))

    # Update method is a little different than you are used to
    # ensure by the time you're calling this everything is validated and safe
    def update(self, *args, **kwargs):
        for k,v in kwargs.items():
            if k == 'password':
                v = User.generate_password(v, str(self.signup_date))
            setattr(self, k, v)

    # Standard authenticate method
    @classmethod
    def authenticate(cls, login, password):
        user = cls.query.find({'$or': [{'username':login}, {'email':login}]}).one()
        if user:
            password = User.generate_password(password, str(user.signup_date))
            if password == user.password:
                return user
        else:
            return None

    # Password hashing
    @staticmethod
    def generate_password(password, salt):
        password = sha1(password).hexdigest() + salt
        return sha1(password+SALT).hexdigest()

    # Username generation, the username generation is very useful if you use social auth
    @staticmethod
    def random_username(_range=5, prefix=''):
        return prefix + ''.join([choice(CHARS) for i in range(_range)])

</pre>

And there you have it, if you tie all the elements together you get a pretty easy and straightforward Ming integration with Pyramid.
