---
categories: ["python", "code"]
date: 2008/08/19 16:41:51
guid: http://pieceofpy.com/?p=61
permalink: http://pieceofpy.com/2008/08/19/code-buffer-cgi-file-uploads-in-windows/
tags: python, code
title: 'Code: Buffer CGI file uploads in Windows'
---
Note to self, when handling CGI file uploads on a Windows machine, you need the following boiler plate to properly handler binary files.
[sourcecode language='python']
try: # Windows needs stdio set for binary mode.
    import msvcrt
    msvcrt.setmode (0, os.O_BINARY) # stdin  = 0
    msvcrt.setmode (1, os.O_BINARY) # stdout = 1
except ImportError:
    pass
[/sourcecode]
Also, if you're handling very large files and don't want to eat up all your memory saving them using the copyfileobj method, you can use a generator to buffer read and write the file.

[sourcecode language='python']
def buffer(f, sz=1024):
    while True:
        chunk = f.read(sz)
        if not chunk: break
        yield chunk
# then use it like this ...
for chunk in buffer(fp.file)
[/sourcecode]
