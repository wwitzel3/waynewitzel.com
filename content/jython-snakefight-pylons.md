---
categories: ["python", "tdd", "pylons", "sqlalchemy", "personal", "jython"]
date: 2009/03/13 17:42:34
guid: http://pieceofpy.com/?p=254
permalink: http://pieceofpy.com/2009/03/13/jython-25-and-snakefight-for-deploying-pylons-w-sqlalchemy-oracle/
tags: ["python", "tdd", "pylons", "jython"]
title: Jython 2.5 and snakefight for deploying Pylons w/ SQLAlchemy + Oracle.
---
<strong>UPDATE / 13 March 2009: </strong><a href="http://pypi.python.org/pypi/snakefight">snakefight 0.3</a> now has a --include-jar option, prefer that to using my hack.

After reading <a href="http://dunderboss.blogspot.com/2009/03/deploying-pylons-apps-to-java-servlet.html">P. Jenvey's blog post about Deploying Pylons Apps to Java Servlet Containers</a> I immediately downloaded the Jython 2.5 beta and installed snakefight to give it a try. One of our services where I work is a Pylons based application. It is deployed using paster and Apache ProxyPass. Our main application is written in Java and is deployed as a war under Jetty. So if I can get my Pylons application built as a war and deployed that way, it would greatly simplify our deployment process.

[sourcecode language="bash"]
$ sudo /opt/jython25/bin/easy_install snakefight
$ /opt/jython25/bin/jython setup.py develop
$ /opt/jython25/bin/jython setup.py bdist_war --paster-config dev_r2.ini
... output of success and stuff ...
$ cp dist/project-0.6.8dev.war /opt/jetty/webapps
[/sourcecode]

Now I visit my local server and hit the project context. I get some database errors, kind of expected them. So for the time being, I'll be running this directly using Jython to speed up the debugging process. A quick googling of my DB issues turns up <a href="http://pylonshq.com/pasties/77c3184b14d6936d86d13e4e65df92d2">zxoracle for SQLalchemy</a> which uses Jython zxJDBC. I install that in to sqlalchemy/databases as zxoracle.py and give it another go. Changing the oracle:// lines in my .ini file to now read zxoracle:// Now it can't find the 3rd party Oracle libraries (ojdbc.jar).

[sourcecode]
$ cd ./dist
$ jar xf project-0.6.8dev.war
$ cd WEB-INF/lib
$ ls
# no ojdbc.jar as expected ...
$ cd ~/project
$ export CLASSPATH=/opt/jython25/jython.jar:/usr/lib/jvm/java/jre/lib/ext/ojdbc.jar
$ /opt/jython25/bin/jython /opt/jython25/bin/paster serve --reload dev_r2.ini
[/sourcecode]

Now it is looking a little better and it able to find the jar, but still a DB issue, now with SQLalchemy library. Not having a ton of time to investigate, I decide to try rolling back my SQAlachemy version for Jython. Turns out rolling back to 0.5.0 fixed the issue. I'll be investigating why it was breaking with 0.5.2 soon (tm). So now I rerun it, and get a new error.

[sourcecode lang="bash"]
AttributeError: 'ZXOracleDialect' object has no attribute 'optimize_limits'
[/sourcecode]

I decide I am just going to go in to the <a href="http://trac.pieceofpy.com/pieceofpy/browser/snakefight-java-libs">zxoracle.py and add optimize_limits = False to the ZXOracleDialect</a>. No idea what this breaks or harms, but I do it anyway and rerun the application. Success! Every thing is working now. No liking the idea of having to manually insert the Oracle jar in to the WEB-INF/lib and not really wanting to much around with environment variables, I also implemented a quick and dirty include-java-libs for snakefight, the diff for command.py is below. This allows me to pass in a : separated list of jars to include in the WEB-INF/lib. <strong>EDIT: </strong>The diff I posted isn't needed since I put it on my hg repo. <a href="http://trac.pieceofpy.com/pieceofpy/browser/snakefight-java-libs">You can grab it from here.</a>

So now I am back to building my war. Just as before.
[sourcecode lang="bash"]
$ /opt/jython25/bin/jython setup.py bdist_war --paste-config dev_r2.ini --include-java-libs /opt/jython25/extlibs/ojdbc.jar
running bdist_war
creating build/bdist.java1.6.0_12
creating build/bdist.java1.6.0_12/war
creating build/bdist.java1.6.0_12/war/WEB-INF
creating build/bdist.java1.6.0_12/war/WEB-INF/lib-python
running easy_install project
adding eggs (to WEB-INF/lib-python)
adding jars (to WEB-INF/lib)
adding WEB-INF/lib/jython.jar
adding Paste ini file (to dev_r2.ini)
adding Paste app loader (to WEB-INF/lib-python/____loadapp.py)
generating deployment descriptor
adding deployment descriptor (WEB-INF/web.xml)
created dist/project-0.6.8dev-py2.5.war
$ cp dist/project-0.6.8dev-py2.5.war /opt/jetty/webapps
$ sudo /sbin/service jetty restart
[/sourcecode]

And presto! I am in business. My pylons application is deployed under Jetty and all the <a href="http://seleniumhq.org/">selenium functional tests</a> are passing. I am sure there is probably a easier, neater, or cleaner way to do all this, but this was my first iteration through and also my first time ever deploying a WAR to a java servlet container so all in all I am happy with the results. Performance seems about the same as when running the application with paster serve, but Jetty does use a little more memory than before (expected I guess).
