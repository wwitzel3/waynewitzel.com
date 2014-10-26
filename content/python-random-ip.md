---
categories: ["python"]
date: 2010/12/22 18:44:30
tags: python, snippets
title: Random IP Address in Python
---
I needed to generate a random IP address for some testing with Google Maps API. Using GeoIP to place a pin when users of a site interact with it. The site is based in the US and will only have US users. I have a list of network ranges from MaxMind in a file. I want to randomly select a network and then randomly select an IP address from that network so the functional testing for the Google Maps and GeoIP integration is a bit more robust. The solution was a nice little algorithm from a <a href="http://stackoverflow.com/questions/3540288/how-do-i-read-a-random-line-from-one-file-in-python/3540315#3540315">SO question</a> and the using the <a href="http://code.google.com/p/ipaddr-py/">ipaddr library</a>.

<p>
<pre class="brush: py">
# randomly select a line from the file
import random

def random_line(afile):
    line = next(afile)
    for num, aline in enumerate(afile):
        if random.randrange(num + 2): continue
        line = aline
 return line
</pre>        
</p>

Then once I have that line, I feed it in to ipaddr and select a random IP address from the network. This is done using randrange and with the fact the ipaddr supports int casting for IP addresses.

<p>
<pre class="brush: py">    
import ipaddr

network = ipaddr.IPv4Network(random_line(open('networks.txt')))
randmon_ip = ipaddr.IPv4Address(random.randrange(int(network.network) + 1,
                                                 int(network.broadcast) - 1))
</pre>
</p>
