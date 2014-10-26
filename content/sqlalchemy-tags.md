---
categories: ["python", "sqlalchemy"]
date: 2008/10/09 15:10:39
guid: http://pieceofpy.com/?p=164
permalink: http://pieceofpy.com/2008/10/09/tags-with-sqlalchemy/
tags: ["python", "sqlalchemy"]
title: Tags with SQLalchemy
---
You see lots of examples on the net for SQLalchemy. Implementing a blog, implementing a wiki, even other articles on implementing tags. Some are good, some are pretty poor, and some are just plain out of date. After some researching on best practices for implementing a Tag system with SQLalchemy I've come up with the solution you are about to read.

I've pulled these examples from real world production code. Just renamed them and shortened them up a little for the blog post. I pulled the naming convention right from SimpleSite example for Pylons. Here is the the table layout. Simple. A page, tag, and relation table.

<p>
<pre class="brush: py">
page_table = sa.Table("page", meta.metadata,
    sa.Column("id", sa.types.Integer, sa.schema.Sequence('page_seq_id', optional=True), primary_key=True),
    sa.Column("name", sa.types.Unicode(100), nullable=False),
)

tag_table = sa.Table("tag", meta.metadata,
    sa.Column("id", sa.types.Integer, sa.schema.Sequence('taq_seq_id', optional=True), primary_key=True),
    sa.Column("name", sa.types.Unicode(50), nullable=False, unique=True),
)

pagetag_table = sa.Table("pagetag", meta.metadata,
    sa.Column("id", sa.types.Integer, sa.schema.Sequence('pagetag_seq_id', optional=True), primary_key=True),
    sa.Column("pageid", sa.types.Integer, sa.schema.ForeignKey('page.id')),
    sa.Column("tagid", sa.types.Integer, sa.schema.ForeignKey('tag.id')),
)
</pre>
</p>

Now the important part, the mapper. The mapper is what is going to tell sqlalchemy what you are trying to do and how to handle and relate those ForeignKeys. It does the heavy lifting so you don't have to.

<p>
<pre class="brush: py">
class Tag(object):
    pass
    
class Page(object):
    pass

orm.mapper(Tag, tag_table)
orm.mapper(Page, page_table, properties = {
    'tags':orm.relation(Tag, secondary=pagetag_table, cascade="all,delete-orphan"),
})
</pre>
</p>

This does two things. It setups the relationship and also uses the built-in cascade rule from SQLalchemy to ensure that no orphan tags are left in the database.

So now we can use this model setup like so. Here, I've just started up my paster shell so I could work through some quick usage examples.

<p>
<pre class="brush: py">
page = model.Page()
page.name = "Example Page"

tag = model.Tag()
name = "tag"

page.tags.append(tag)
meta.Session.save(page)
meta.Session.commit()

tag_q = meta.Session.query(model.Tag)
tags = tag_q.all()
len(tags)

# filter pages by tag(s)
page_q = meta.Session.query(model.Page)
pages = page_q.join('tags').filter_by(name="tag").all()

# delete-orphans does the work for us here...
meta.Session.delete(pages[0])
meta.Session.commit()

tags = tag_q.all()
len(tags)

# tag cloud anyone?
# see the source code linked below for a properly weighted tag cloud.
tag_q = meta.Session.query(func.count("*").label("tagcount"), model.Tag)
tag_r = tag_q.filter(model.Tag.id==model.pagetag_table.c.tagid).group_by(model.Tag.id).all()

# what about pages with related tags?
page_q = meta.Session.query(model.Page)

taglist = ["tag1", "tag2"]
tagcount = len(taglist)
page_q.join(model.Page.tags).filter(model.Tag.name.in_(taglist)).\
group_by(model.Page.id).having(func.count(model.Page.id) == tagcount).all()
</pre>
</p>

Ok, now the fun part, what about all related tags? An intersection between an arbitrary number of many-to-many relationships? For that I added a static method to my tag class. Something like this.

<p>
<pre class="brush: py">
class Tag(object):
    @staticmethod
    def get_related(tags=[]):
        tag_count = len(tags)
        
        inner_q = select([pagetag_table.c.pageid])
        inner_w = inner_q.where(
            and_(pagetag_table.c.tagid == Tag.id,Tag.name.in_(tags))
        ).group_by(pagetag_table.c.pageid).having(func.count(pagetag_table.c.pageid) == tag_count).correlate(None)
        
        outer_q = select([Tag.id, Tag.name, func.count(pagetag_table.c.shipid)])
        outer_w = outer_q.where(
            and_(pagetag_table.c.pageid.in_(inner_w),
            not_(Tag.name.in_(tags)),
            Tag.id == pagetag_table.c.tagid)
        ).group_by(pagetag_table.c.tagid)
        
        related_tags = meta.Session.execute(outer_w).fetchall()
        return related_tags
</pre>
</p>

A big thanks to <a href="http://cakephp.org/">PHP-Cake</a> and <a href="http://tagschema.com/">TagSchema</a> for the ideas, concepts, and implementation examples.

You can find the actual code that this blog was the basis for at:
<a href="http://trac.pieceofpy.com/pieceofpy/browser/tags-sqlalchemy">http://trac.pieceofpy.com/pieceofpy/browser/tags-sqlalchemy</a>
