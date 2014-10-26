---
categories: ["python"]
date: 2011/04/27 14:00:00
tags: ["python", "snippets"]
title: Quick SQLalchemy Shell and Blog Update
---

### Update ###
So I haven't updated my blog in a long time. Some people actually apparently still check in and read it every now and again.
A few more, even cared enough to asked me why I haven't updated my blog? Embarassed and ashamed I lied and said,
"Oh I've been busy.". Ok, so not so much busy as lazy. I recently switched to Blogofile and in the process I
never setup my version control to re-build and auto publish my commits to the site. Knowing that it wasn't setup I've been too lazy
to blog because I knew I would have to commit, login, build, and copy the files to the public folder. Yeah seriously, my barrier to
entry for somethings is that low, sue me!

Anyway, I've finally got it all setup to do the build and deploy for me and I even managed to setup SSH keys and have it mirror
the changes up to bitbucket for those interested in the source code of this Blogofile blog.

### Quick SQLalchemy Shell ###
Ok so now for something I use a lot but took for granted until I used it in front of a friend the other day. Who asked me what? how?
A lot of times when I am working with SQLalchemy I just want a quick shell I can jump in to and start poking around.
I use this a lot of when people ask questions on IRC or the ML. It helps me play around with stuff if I don't know the answer right away.
It is also a great resource for myself when testing new features or trying to figure things out. Nice thing is you can also change it to do
reflection and easily have a session in to a pre-existing table structure, which is nice if you are like me and know SA better than SQL.

<p>
The structure of the code is pretty simple:
<ul>
    <li>sqla (folder)</li>
    <ul>
        <li>__main__.py</li>
        <li>models.py</li>
    </ul>
    </li>
</ul>

<pre class="brush: py">
# __main__.py
import os
import sqlalchemy as sa

from models import *

os.environ['PYTHONINSPECT'] = 'True'
engine = sa.create_engine('sqlite:///:memory', echo=True)
Base.metadata.create_all(engine)
Session = sa.orm.sessionmaker(bind=engine)
session = Session()
</pre>    

And then you have models.py
<pre class="brush: py">
import sqlalchemy as sa
from sqlalchemy.ext.declarative import declarative_base

__all__ = ['Base', 'Test']

Base = declarative_base()

class Test(Base):
    __tablename__ = 'test'
    id = sa.Column(sa.Integer, primary_key=True)
</pre>
</p>

<p>
Now you can run something like this, changing your models to have what ever type of objects and relations you desire.
<pre class="brush: bash">
(sqla)mac-wwitzel:code wayne.witzel$ python sqla
2011-04-27 14:18:45,764 INFO sqlalchemy.engine.base.Engine.0x...d410 
PRAGMA table_info("test")
2011-04-27 14:18:45,764 INFO sqlalchemy.engine.base.Engine.0x...d410 ()
>>> test = Test()
>>> session.add(test)
>>> session.commit()
2011-04-27 14:19:12,011 INFO sqlalchemy.engine.base.Engine.0x...d410 BEGIN (implicit)
2011-04-27 14:19:12,012 INFO sqlalchemy.engine.base.Engine.0x...d410 INSERT INTO test 
DEFAULT VALUES
2011-04-27 14:19:12,012 INFO sqlalchemy.engine.base.Engine.0x...d410 ()
2011-04-27 14:19:12,015 INFO sqlalchemy.engine.base.Engine.0x...d410 COMMIT
>>> t = session.query(Test).first()
2011-04-27 14:19:20,571 INFO sqlalchemy.engine.base.Engine.0x...d410 BEGIN (implicit)
2011-04-27 14:19:20,571 INFO sqlalchemy.engine.base.Engine.0x...d410 SELECT test.id AS 
test_id 
FROM test 
 LIMIT 1 OFFSET 0
2011-04-27 14:19:20,571 INFO sqlalchemy.engine.base.Engine.0x...d410 ()
>>> t
<models.Test object at 0x101643890>
>>>
</pre>
</p>
