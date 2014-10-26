---
categories: ["python", "pyramid"]
date: 2011/08/05 12:00:00
tags: ["python", "whoosh", "pyramid"]
title: Hooking up Whoosh and SQLalchemy (sawhoosh)
---

I was talking to Tim VanSteenburgh (we both do work for Geek.net) and he had a proof of concept for automatically updating a search index when a change happens to a model and pairing a unified search results page with that to make an easy one-stop search solution for a website. I thought this was a pretty cool idea, so I decided to do a implementation of it on top of the Pyramid framework and share it the readers of my blog. I choose Whoosh only so that I could have an easy way for users to try the project out. Since whoosh is pure python it installs when you run your setup.py develop. But this approach could be applied to any searching system. Tim was using solr.

Demo Project
------------
The purpose of the post is to summarize briefly the steps taken to achieve the desired results of automatically updating the index information when models change. Please browse the source and clone and run the project, looking at the source as a whole will definitely give you a better start to finish understanding than just reading this blog post.

GitHub: <a href="https://github.com/wwitzel3/sawhoosh">sawhoosh</a>

Whooshing Your Models
---------------------
There are few parts that make up the magic of all this, but each part is really simple. First you have the index schema itself. This is setup to hold the unique ID of an item, as well as a pickled version of the uninstantiated class, and an aggregate of values (decided by you) that you want to be searchable for the item. The schema looks like this:

<pre class="brush: py">
class SawhooshSchema(SchemaClass):
    value = TEXT
    id = ID(stored=True, unique=True)
    cls = ID(stored=True)
</pre>

In the Whoosh world this basically says store ID and CLS so it comes back with the search results, but not value. value will be what we will search over in order to find our results. We need to tell our models what attributes are important to use for indexing, I've chosen to do this with a whoosh_value property on the model itself.

<pre class="brush: py">
class Document(Base):
    __tablename__ = 'document'
    __whoosh_value__ = 'id,title,content,author_id'
    id = Column(CHAR(32), primary_key=True, default=new_uuid)
    title = Column(String, nullable=False)
    content = Column(Text, nullable=False)
    author_id = Column(Integer, ForeignKey('author.id'), index=True)
    def __str__(self):
        return u'Document - Title: {0}'.format(self.title)
</pre>

This says make the id, title, content, and author_id for document all searchable values. This happens automatically for us because our Base class has a parent class that handles all of the Whoosh work. This parent class, I've called it SawhooshBase, handles all the indexing, reindexing, and deindexing of our models. The class itself looks like this:

<pre class="brush: py">
class SawhooshBase(object):
    # The fields of the class you want to index (make searchable)
    __whoosh_value__ = 'attribue,attribute,...'
    def index(self, writer):
        id = u'{0}'.format(self.id)
        cls = u'{0}'.format(pickle.dumps(self.__class__))
        value = u' '.join([getattr(self, attr) for attr in self.__whoosh_value__.split(',')])
        writer.add_document(id=id, cls=cls, value=value)
    def reindex(self, writer):
        id = u'{0}'.format(self.id)
        writer.delete_by_term('id', self.id)
        self.index(writer)
    def deindex(self, writer):
        id = u'{0}'.format(self.id)
        writer.delete_by_term('id', self.id)
        
Base = declarative_base(cls=SawhooshBase)
</pre>

As you can see in the index method, we use the whoosh_value to create an aggregate of searchable strings and supply that to the value we defined in our search schema. We pickle the class and also store the ID. This is what later lets us easily take search results and turn them in to object instances.

Those methods above are only ever run by our SQLalchemy after_flush session event, though that is not to say you couldn't run them manually. The callback and event hook looks like this:

<pre class="brush: py">
def update_indexes(session, flush_context):
    writer = WIX.writer()
    for i in session.new:
        i.index(writer)
    for i in session.dirty:
        i.reindex(writer)
    for i in session.deleted:
        i.deindex(writer)        
    writer.commit()
event.listen(DBSession, 'after_flush', update_indexes)
</pre>

The WIX object you see being used here is created much the same way you create your DBSession and you can view that in the <a href="https://github.com/wwitzel3/sawhoosh/blob/master/sawhoosh/search.py">search.py</a> file of the project. Everything else is pretty straight forward. Call the respective indexer methods for new, dirty, and deleted items in the session.

Using in the View
-----------------
Now we have our models all ___whooshified___ (technical term) and we want to have our users searching and displaying usable results. To start we have a simple search form that when submitted does a GET request to our search method with keywords. Now since the whoosh query parser is already smart enough to pickup things like AND and OR we don't have to do much.

The view code itself is where we use another helper method called results_to_instance (also in <a href="https://github.com/wwitzel3/sawhoosh/blob/master/sawhoosh/search.py">search.py</a>). This method takes our search results, unpickles the class, fetches the instance from the DB and places the result in to a list. That method looks like this:

<pre class="brush: py">
def results_to_instances(request, results):
    instances = []
    for r in results:
        cls = pickle.loads('{0}'.format(r.get('cls')))
        id = r.get('id')
        instance = request.db.query(cls).get(id)
        instances.append(instance)
    return instances
</pre>

Now this is where you see the benefit of pickling the class type with the search result. We have ready to use instances of multiple types from a single search result. We can pass them in to a template to render the results, but since we have a mix of instance types, we need a unified way to render them out without explicitly checking their type or using a series of if attribute checks. I decided I would use __str__ on the model to be a search results safe friendly way to display the object to the user and that I would define a route_name helper method on the model so that I can use request.route_url(object.route_name()) to generate the clickable links in the results. The combination of this can be viewed below:

<pre class="brush: html">
%if results:
<ul id="search_results">
% for r in results:
    <li><a href="${request.route_url(r.route_name(), id=r.id)}">${r}</a></li>
%endfor
</ul>
%else:
<p>No results found</p>
%endif
</pre>

And the view itself uses some things we haven't talked about yet. QueryParser is just part of Whoosh and it is what turns your keywords in to something useful. request.ix is just a shortcut to our WIX object we created, we've added it using a custom Request class (same as we've done with db), you can see that in the <a href="https://github.com/wwitzel3/sawhoosh/blob/master/sawhoosh/security.py">security.py</a> file of the project. From there we render the search results html and return it to our AJAX caller to inject in to the page. You can see this is also where we use the results_to_instances method discussed earlier.

<pre class="brush: py">
@view_config(route_name='search', renderer='json', xhr=True)
def search_ajax(request):
    query = request.params.get('keywords')
    parser = QueryParser('value', request.ix.schema)
    with request.ix.searcher() as searcher:
        query = parser.parse(query)
        results = searcher.search(query)
        search_results_html=render('sawhoosh:templates/search/results.mako',
                              dict(results=results_to_instances(request, results)),
                              request=request)
    return dict(search_results_html=search_results_html)
</pre>

Summary
-------
There you have it. A search indexer using SQLalchemy on top of Pyramid. I highly recommend you clone the git repo for this project or review the code using the Git website if you are interested in getting a start to finish feel. The project allows you to add Authors and Documents and Edit and Delete them all while updating the local search index stored in the a directory on the file system.

GitHub: <a href="https://github.com/wwitzel3/sawhoosh">sawhoosh</a>
