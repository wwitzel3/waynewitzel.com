---
categories: ["python", "pylons", "deploy"]
date: 2008/10/06 13:43:06
guid: http://pieceofpy.com/?p=147
permalink: http://pieceofpy.com/2008/10/06/deploying-pylons-with-nginx/
tags: ["paster", "python", "pylons", "nginx"]
title: Deploying Pylons with nginx
---
In preparation for a production deployment of a new Pylons app, I've been looking in to different deployment methods. In an effort to to be /. safe and Diggable when the new application launches, we've decided on 4 server deployment.

<ul>
	<li>1 nginx server</li>
	<li>2 pylons (paster) servers</li>
	<li>1 postgresql server</li>
</ul>
I built nginx from the source without issues. The default install location of /usr/local/nginx works for me. You'll need to make any init scripts and install them, see your platform doucmentation for how to do this. You'll also want to be sure to add the new log dir to any log stats/consolidating/trimming jobs you run.

Here is the important parts of the nginx configuration for proxying to the Paster servers. Also be sure you adjust your keep alive and connection timeout settings, if you have just a standard Ajaxy Web 2.0 application, you'll want to kick that down to 5 5 or 5 10. They default is way to high unless you're doing constant streaming of live updates or something to that degree.

<pre>
worker_processes  2;
events {
    worker_connections  1024;
}
http {
    client_body_timeout   5;
    client_header_timeout 5;
    keepalive_timeout     5 5;
    send_timeout          5;
    
    tcp_nodelay on;
    tcp_nopush  on;

    gzip              on;
    gzip_buffers      16 8k;
    gzip_comp_level   1;
    gzip_http_version 1.0;
    gzip_min_length   0;
    gzip_types        text/plain text/html text/css;
    gzip_vary         on;

    upstream pasters {
        server 10.3.0.5:5010;
        server 10.3.0.6:5011;
    }
    server {
        listen       80;
        server_name  localhost;

        location / {
            proxy_pass http://pasters;
            proxy_redirect default;
        }
    }
</pre>

The paster servers are setup like this, I put them both in the same .ini and setup them up in the tpl. This lets me do an easy_install , setup-app based deployment without having to manually edit the ini to change the port numbers, which is error prone. This also lets you adjust and tune per server, instead of deploying 1 server section and changing it for each. Example would be if one server was way more powerful, you could tune it and then use the weighting in nginx to prefer that server. All without having to edit the ini after deployment.

<pre>
[server:main]
use = egg:Paste#http
host = 0.0.0.0
port = 5010
use_threadpool = True
threadpool_workers = 10

[server:main2]
use = egg:Paste#http
host = 0.0.0.0
port = 5011
use_threadpool = True
threadpool_workers = 10
</pre>

Using 10 1000 on Apache bench gave me some good results. 85 requests per second to either of the standalone Paster servers. 185 requests per second when balanced with nginx. For fun, I deployed a third on my database server and was pleased to see 250 requests per second. Then I deployed 3 per server. So a total of 9 paster instances and was able to see 1080 requests per second. I also increased the thread of each from 10 to 25 , this uses more memory, but enables a higher RPS.

Getting closer to the estimated 2,500 needed to survive a /. and should survive the estimated 1,000 from a high Digg.
