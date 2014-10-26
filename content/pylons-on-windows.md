---
categories: ["python", "pylons", "deploy"]
date: 2008/10/07 14:00:36
guid: http://pieceofpy.com/?p=160
permalink: http://pieceofpy.com/2008/10/07/how-to-python-pylons-and-windows/
tags: python, pylons, windows, deploy
title: 'How-To: Python, Pylons, and Windows'
---
A friend having issues installing Pylons on Windows XP with Python 2.6 gave me the idea to do this quick write up. So here it is, the 6 step method for running Pylons on Windows XP.
<ul>
	<li>Download <a href="http://python.org">Python</a>.</li>
	<li>Add Python to your path and launch a command prompt.</li>
	<li>Download <a href="http://peak.telecommunity.com/DevCenter/EasyInstall">ez_setup.py</a>, python ez_setup.py</li>
	<li>Download <a href="http://pypi.python.org/pypi/simplejson">simplejson</a>, python setup.py --without-speedups install</li>
	<li>easy_install Pylons</li>
        <li>easy_install formbuild</li>
	<li>Do a quick test; paster create --template=pylons</li>
</ul>
And that is all she wrote. Pretty easy. The reason we install simplejson seperate is because the default behavior is to build with speedups and well .. by default, that behavior won't work on a standard Windows XP machine. So we install it seperate to avoid any conflicts.





