---
categories: ["python", "sqlalchemy"]
date: 2011/10/12 20:25:00
permalink: http://pieceofpy.com/2011/10/12/sqlalchemy-custom-types-integers-datetime
tags: python, sqlalchemy
title: Using SQLAlchemy Custom Types to Convert Integers to DateTime
---

Today I was working on fetching out some data from an existing PostgreSQL server and generating
some BSON output that would later be imported in to MongoDB. One of the problems I ran in to was
that I needed to format the timestamps easily for each row of data.

Searching the internet I ran across <a href="http://threebean.wordpress.com/2011/09/01/automatically-converting-integer-timestamps-to-python-datetime-in-reflected-sqlalchemy-models/">this blog post by Ralph Bean</a>, which does just that, but at a level
that was well beyond what I needed. So taking away some inspiration from Ralph's blog post, I decided
to just go with a <a href="http://www.sqlalchemy.org/docs/core/types.html#custom-types">Custom Type</a>.

<pre class="brush: py">
from time import mktime
from datetime import datetime

class IntegerDateTime(types.TypeDecorator):
    """Used for working with epoch timestamps.

    Converts datetimes into epoch on the way in.
    Converts epoch timestamps to datetimes on the way out.
    """
    impl = types.INTEGER
    def process_bind_param(self, value, dialect):
        return mktime(value.timetuple())
    def process_result_value(self, value, dialect):
        return datetime.fromtimestamp(value)
</pre>

Then in my reflected table, I just override the column that holds the integer representation of the
datetime I want.

<pre class="brush: py">
group_table = sa.Table('groups', metadata,
    sa.Column('register_time', IntegerDateTime),
    autoload=True,
    include_columns=[
        'group_id',
	'register_time',
	'type'
    ],
)
</pre>

Now when we query and begin to use our results, register_time will be a DateTime object making it
very easy to do any timedelta arithmetic or string formatting.

