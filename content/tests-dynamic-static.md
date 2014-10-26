---
categories: ["python", "brainstorm", "c++"]
date: 2009/04/20 01:20:58
guid: http://pieceofpy.com/?p=296
permalink: http://pieceofpy.com/2009/04/20/dynamic-and-static-typing-with-unit-tests/
tags: ''
title: Dynamic and static typing with unit tests.
---
There is an on going discussion at the office with a team member who refuses to use dynamic languages. Claiming that most of his errors are typographical errors and they are caught by the compiler. So for him, since these errors are not caught until runtime, he throws and entire group of languages out the window. He also claims that to ensure that same level of checking with a dynamic language you would have to create more unit tests than normal to prevent introducing unhandled runtime exceptions.

So I decided to do a little test over the weekend. I created a very simple Number class in Python and C++. Using the exact same TDD development process, I implemented some very basic operations including division, addition, subtraction, etc... I ended up with 12 tests. The exact same tests for both the C++ and Python implementation resulting in 100% of the executation path being covered. I decided that the compliation (in case of C++) and passing of the tests determined a success.

Then went back and inserted common typographical errors. Mistypes, extra = signs, not enough = signs, miseplled_varaibles, etc... The end result was I was unable to get my unit tests passing while introducing syntax that would induce an unhandled runtime exception in Python. Granted, in C++ the compiler did catch a lot of things for me, but the point here is I didn't have to create any extra tests to ensure that same level of confidence in my Python code.
