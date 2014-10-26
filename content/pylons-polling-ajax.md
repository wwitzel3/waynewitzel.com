---
categories: ["python", "code", "pylons"]
date: 2009/02/04 19:11:07
guid: http://pieceofpy.com/?p=226
permalink: http://pieceofpy.com/2009/02/04/pylons-and-long-live-ajax-request/
tags: ["pylons", "ajax", "code", "python"]
title: Pylons and long-live AJAX request.
---
So I am playing around in Firefox with XMLHttpRequest. Looking in to a way to facilate a server update to a client without have to refresh the page or use Javascript timers. So the long-live HTTP request seems the way to go.

This little app will at most have 20-30 connections at once, so I am not worried about the open connection per client. The data it calculates is rather large and intensive to gather, so I paired it with the cache decorator snippet found on ActiveState and used in Expert Python Programming. This example feeds a cached datetime string. The caching lets different client receive the same data during the cache process. There is some lag between the updates since they all set their sleep at different points, there may be away around this though.

So here is my basic index.html.
[sourcecode language="html"]
<body>
<em>This will push data from the server to you every 5 seconds .. enjoy!</em>
<ul id="container"></ul>

<script>
var div = document.getElementById('container');
function handleContent(event)
{
  var xml_packet = event.target.responseXML.documentElement;
  div.innerHTML += '<li>' + xml_packet.childNodes[0].data + '</li>';
}
(function () {
    var xrequest = new XMLHttpRequest();
    xrequest.multipart = true;
    xrequest.open("GET","/server/index",false);
    xrequest.onload = handleContent;
    xrequest.send(null);
})();

</script>
</body>
[/sourcecode]

Now the controller code itself.
[sourcecode language="python"]
class ServerController(BaseController):    
    def index(self):
        response.headers['Content-type'] = 'multipart/x-mixed-replace;boundary=test'
        return data_stream()

def data_stream(stream=True):
    yield datetime_string()
    
    while stream:
        time.sleep(5)
        yield datetime_string()

@memorize(duration=15)
def datetime_string():        
    content = '--test\nContent-type: application/xml\n\n'
    content += '<?xml version=\'1.0\' encoding=\'ISO-8859-1\'?>\n'
    content += '<message>' + str(datetime.datetime.now()) + '</message>\n'
    content += '--test\n'
    
    return content
[/sourcecode]

Also the decorator code for good measure.
[sourcecode language="python"]
cache = {}

def is_old(entry, duration):
    return time.time() - entry['time'] > duration

def compute_key(function, args, kw):
    key = pickle.dumps((function.func_name, args, kw))
    return hashlib.sha1(key).hexdigest()

def memorize(duration=10):
    def _memorize(function):
        def __memorize(*args, **kw):
            key = compute_key(function, args, kw)
            
            if (key in cache and not is_old(cache[key], duration)):
                return cache[key]['value']
            result = function(*args, **kw)
            cache[key] = {'value': result, 'time':time.time()}
            return result
        return __memorize
    return _memorize
[/sourcecode]

Full working demo will be available in the HG repos shortly.
