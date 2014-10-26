---
categories: ["python", "pyramid"]
date: 2011/07/24 12:00:00
tags: python, pyramid
title: Pyramid and velruse for Google authentication
---

As I continue to work with Pyramid I find myself really enjoying the web development I am doing. Recently I needed to integrate Google OAuth (and eventually Facebook and Twitter) as part of the options for the user signup experience. I knew <a href="http://cd34.com/blog/">Chris Davies</a> has done something similar recently based on some Google+ activity I had read of his, so while I was exploring options, I also spoke with him about his experience with python-openid and velruse. The feedback and examples he gave to me are pretty much the basis for what you are about to read on how to get Google OAuth working with your Pyramid application.

This post only describes how to do the Google Authentication with Pyramid and velruse, but you can easily adapt the information in the post to work with Twitter and Facebook. All the code that these snippets were taken from are available in their entirety in the <a href="https://sourceforge.net/p/stockpot/code/">stockpot git repository</a> on Sourceforge.

### Setting it all up ###
When I first looked at <a href="http://packages.python.org/velruse">velruse</a> I was a little intimidated. The documentation isn't the greatest in the world and the code is very compact (but well done), so it took a bit for me to become comfortable with it. After some code reading and submitting a <a href="https://github.com/bbangert/velruse/pull/21">small fix so it could use SQLite as a storage type</a> I was ready to rock and roll.

Once I had it pip installed and in my setup.py as a requirement the next step was to setup the ini to create and serve an instance of verluse along side my pyramid application. Here are the app and pipeline sections of the ini file.

<pre class="brush: py">
[app:stockpot]
use = egg:stockpot
default_locale_name = en

[app:velruse]
use = egg:velruse
config_file = %(here)s/CONFIG.yaml

[pipeline:pstockpot]
pipeline = exc tm stockpot

[pipeline:pvelruse]
pipeline = exc tm velruse

[composite:main]
use = egg:Paste#urlmap
/ = pstockpot
/velruse = pvelruse
</pre>

### Integrating the pieces ###
velruse is configured using a YAML file. This file at a minimum needs a Store, which will hold the key,value pairs your callback receives. It also needs the OpenID and OpenID store which hold the generic realm, endpoint regex, and store information for all the providers. It is important for most providers that your realm and endpoint match what you've setup in their system.

***Tip:*** *Use /etc/hosts file to point to your local machine so that when you are redirected to the endpoint with the GET token your application receives everything ok*

<pre class="brush: xml">
Store:
    Type: SQL
    DB: sqlite:////path/to/data/stockpot.db
Google:
    OAuth Consumer Key: MYKEY
    OAuth Consumer Secret: MYSECRET
OpenID:
    Realm: http://example.com:6543
    Endpoint Regex: http:/example.com
OpenID Store:
    Type: openid.store.memstore:MemoryStore
</pre>

Now in your Pyramid application you will need to do some setup.

You will need to make sure that the KeyStorage table is being created along with your application tables and you will also need to create a callback method to handle the response from the OAuth endpoint. Also somewhere you'll need to add a simple view that contains the Google Login form.

<pre class="brush: html">
<form action="/velruse/google/auth" method="post">
<input type="hidden" name="popup_mode" value="popup" />
<input type="hidden" name="end_point" value="http://communitycookbook.net:6543/login" />
<input type="submit" value="Login with Google" />
</form>
</pre>

And here is the simple addition to the models. This assumes you are using the same DB for your application and velruse.

<pre class="brush: py">
from velruse.store.sqlstore import SQLBase

## inside initialize_sql
SQLBase.metadata.bind = engine
SQLBase.metadata.create_all(engine)
</pre>

I added the callback code to my existing login handler, it looks for the token, attempts to lookup the values for that token in the KeyStorage of velruse. Upon the success of the lookup it loads the JSON string, extracts the verifiedEmail. The email is used to lookup a pre-existing user or create a new one if it doesn't exist. Then we call remember with the request and the user.id just like normal. Now we have a logged in user.

<pre class="brush: py">
if 'token' in request.params:
    try:
        token = request.params.get('token')
        storage = DBSession.query(KeyStorage).filter_by(key=token).one()
        values = json.loads(storage.value)
        if values.get('status') == 'ok':
            email = values.get('profile',dict()).get('verifiedEmail')
            try:
                user = DBSession.query(User).filter_by(email=email).one()
            except orm.exc.NoResultFound:
                user = User(email)
                request.db.add(user)
                request.db.flush()

            headers = remember(request, user.id)
            return HTTPFound(location=resource_url(request.next, request),
                             headers=headers)
    except orm.exc.NoResultFound:
        request.session.flash('Unable to Authenticate you using OpenID')
</pre>

From here you can treat this user like any other. They have created an entry in your user table and you can start adding the user to groups or setting permanent properties on the user. All in all a pretty simple process when you put it down on paper, but I know for me it all felt a little overwhelming until I actually got it all put together and working.

### Feedback ###
If you know of ways to improve the code or see obviously glaring issues please leave a comment or email me at my first name @ pieceofpy.com.
