---
categories: ["books", "tdd"]
date: 2008/08/11 18:52:50
guid: http://pieceofpy.com/?p=86
permalink: http://pieceofpy.com/2008/08/11/book-test-driven-development-by-example-refresher/
tags: book, tdd
title: 'Book: Test Driven Development by Example (Refresher)'
---
I found an old book on the shelf the other day. One I hadn't worked through in some time. "Test Driven Development By Example" by Kent Beck. It was one of the first books I had ever picked up and read about test driven development and really kicked off my shift in towards TDD and other agile practices.

So with this nostalgia, I decided I'll grab the book and work through it once again. Cover to cover, as my ode to the first book that radically changed how I felt and thought about programming in a long time and as a refresher course for the real basics of TDD, since I notice myself falling in to some poor patterns at work.

One thing that stood out to me right away and this goes back to what I had mentioned earlier about some poor patterns at work. I had pretty much completely forgotten about how/when/why to triangulate. I am not a giant fan of it over all, but when dealing with very complex systems and your brain just won't give you the obvious implementation and there is no static value to make a test pass. Triangulation really shines in this instance and right after reading the chapter that covered it, I opened the VPN and got a requirement crossed of my list by triangulating with my test case.

For those not familiar with the practices within TDD, the break down is simple. Tests first, write passing code as fast as possible, refactor code. With triangulation, you use your test to drive the how a method or class develops. With triangulation you don't change your exist tests, you just add new requirements to them. We'll you a very simple example of a Number class.

[sourcecode language='python']
def test_Equality():
 assert Number(10) == Number(10)
[/sourcecode]

That might be your first test. Very easy to make pass. Just have Number constructor return 10. Green light, go home. So imagine this like some complex class we are trying to add this functionality on to. Here is how you'd modify the test to begin the triangulation process.

[sourcecode language='python']
def test_Equality():
 assert Numer(10) == Number(10)
 assert Number(10) != Number(15)
[/sourcecode]

You see? Now, returning 10 won't work. So now you've got another very small piece to implement. You continue to do this in very small pieces until you have a eureka moment and begin to see the obvious solutions as you make more tests or until you've taken 1000 baby steps and built the whole class.

Anyway, I've worked through the first serveral chapaters so far. I'll have a link to the TDD source once my repository is back online.
