---
categories: ["python", "pyramid"]
date: 2012/07/17 07:25:00
permalink: http://pieceofpy.com/2012/07/17/pyramid-json-serialize-custom-objects
tags: ["python", "pyramid"]
title: Pyramid - JSON Serialize Custom Objects
---

When writing web application that expose an API, at some point we end up
needing to serialize our custom objects. We create these objects
ourselves and other times we are using third-party libraries.

Fortunately the latest Pyramid master has new features that allow you to
easily define a serialization protocol for custom objects.

We provide you with two approaches, the first one will feel familar if you have
used TurboGears. The second allows you to handle the serialization
of any object, even those third-party ones you didn't write.

<h3>Using __json__</h3>
Using the \_\_json\_\_ method is great when you want an easy way to serialize your
own objects. All you need to do is define a \_\_json\_\_ method on your class and
use the default json renderer on your view. Like this.

<pre class="brush: py">

class CustomObject(object):
    def __init__(self, name, email):
        self.name = name
        self.email = email
        self.timestamp = datetime.utcnow()
    def __json__(self, request):
        return dict(
            name=self.name,
            email=self.email,
            timestamp=self.timestamp.isoformat(),
            )

@view_config(route_name="custom_object", renderer="json")
def custom_object(request):
    from objects import CustomObject
    results = dict(
        count=2,
        objects=[
            CustomObject('Wayne Witzel III', 'wayne@pieceofpy.com'),
            CustomObject('Fake Person', 'fake.person@pieceofpy.com'),
            ],
        )

    return results

</pre>

You can see here, this is taking the non-serializable datetime that is part
of your custom object and turning it into a serializable string using the
isoformat call. The default json renderer looks for this special \_\_json\_\_ method.
Once you have that defined, there is nothing more for us to do. As long as the
return of \_\_json\_\_ is serializable, everything is handled for us. Even when
returning lists of custom objects, like say the results of a SQL query.

<h3>Using add_adapter</h3>

Now if extending the object itself isn't desirable, you can use a custom
adapater. This uses a type checking approach, that registers a serialization
method for a specific type. It has a little more setup than the \_\_json\_\_ 
approach above, but is great when dealing with built-in types of third party
objects.

First we create a method that knows how to serialize our object.

<pre class="brush: py">

class ThirdPartyObject(object):
    def __init__(self):
        self.value = Decimal(0.1)

def third_party_adapter(obj, request):
    return dict(
        value=str(obj.value),
        )

</pre>

So here, we define a very simple adapter that knows how to deal with our
Decimal value. Now in our \_\_init\_\_ we need to tell Pyramid about
this custom method.

<pre class="brush: py">
json_third_party = JSON()
json_third_party.add_adapter(ThirdPartyObject, third_party_adapter)
config.add_renderer('json_third_party', json_third_party)
config.add_route('third_party', '/third_party.json')
</pre>

Finally we can now tell our view to use our newly registered json\_third\_party
renderer when our view returns.

<pre class="brush: py">
@view_config(route_name="third_party", renderer="json_third_party")
def third_party(request):
    from objects import ThirdPartyObject
    results = dict(
        count=1,
        objects=[
            ThirdPartyObject(),
            ],
        )
    return results
</pre>

As you can see if is very easy to configure Pyramid to JSON serialize custom
objects even if you aren't the original author or don't want to modify the
code of an object.

<h3>Resources</h3>

You can try out this feature by checking out the <a href="https://github.com/Pylons/pyramid">latest copy of Pyramid master
from Github</a>. A working Pyramid demo for this blog post is <a href="https://github.com/wwitzel3/pieceofpy/tree/master/json_serialize_demo">available here</a>.

Reference: <a href="http://docs.pylonsproject.org/projects/pyramid/en/master/narr/renderers.html#json-serializing-custom-objects">Renderers</a>
