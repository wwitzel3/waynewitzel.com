---
categories: ["python", "sqlalchemy"]
date: 2011/10/13 14:40:00
permalink: http://pieceofpy.com/2011/10/13/sqlalchemy-cleanup-challenge
tags: python, sqlalchemy
title: SQLalchemy Cleanup Challenge
---
Yesterday I found myself writing some very interesting SQLalchemy. The problem is I have a date column in
PostgreSQL that is stored as epoch time, so it is just an Interger column. I need to group by year,month and
grab the total count of status='A' groups for that year,month combination.

Here is what I came up with, can you make it cleaner? Faster? I am curious to see the different variations
people come up with.

<pre class="brush: py">
        pg_date_part_month = sa.func.date_part('month',
                sa.func.to_timestamp(Group.register_time))
        pg_date_part_year = sa.func.date_part('year',
                sa.func.to_timestamp(Group.register_time))

        group_month_select = ( 
            db.query(
                sa.sql.label('year', pg_date_part_year),
                sa.sql.label('month', pg_date_part_month),
                sa.sql.label('total', sa.func.count(Group.status))
            )   
            .filter_by(status='A')
            .group_by(pg_date_part_year)
            .group_by(pg_date_part_month)
            .group_by(Group.status)
            .order_by(pg_date_part_year)
            .order_by(pg_date_part_month)
        )
</pre>

