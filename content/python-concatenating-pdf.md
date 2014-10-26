---
categories: ["python", "code"]
date: 2009/03/05 14:33:07
guid: http://pieceofpy.com/?p=229
permalink: http://pieceofpy.com/2009/03/05/concatenating-pdf-with-python/
tags: python, pdf, concatenate
title: Concatenating PDF with Python
---
I need to concatenate a set of PDFs, I will take you through my standard issue Python development approach when doing something I've never done before in Python.

My first instinct was to google for pyPDF. Success! So, fore go reading any doc and just give the old easy_install a try.

<pre class="brush: bash">
$ sudo easy_install pypdf
</pre>

Another success! Ok, a couple help() calls later and I am ready to go. The end result is surprisingly small and seems to run fast enough even for PDFs with 50+ pages.

<pre class="brush: py">
from pyPdf import PdfFileWriter, PdfFileReader

def append_pdf(input,output):
    [output.addPage(input.getPage(page_num)) for page_num in range(input.numPages)]

output = PdfFileWriter()
append_pdf(PdfFileReader(file("sample.pdf","rb")),output)
append_pdf(PdfFileReader(file("sample.pdf","rb")),output)

output.write(file("combined.pdf","wb"))
</pre>
