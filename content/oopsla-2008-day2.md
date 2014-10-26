---
categories: ["community"]
date: 2008/10/21 04:55:43
guid: http://pieceofpy.com/?p=190
permalink: http://pieceofpy.com/2008/10/21/oopsla-2008-day-2/
tags: ["community", "oopsla"]
title: OOPSLA 2008 - Day 2
---
After a goodnight sleep, I mange to NOT be late for this mornings tutorial sessions. Today I have planned to attend <em>Advanced Software Architecture</em> and <em>Pattern-Oriented Software Architecture: A Pattern Language for Distributed Computing.<strong> </strong></em>

<strong>Advanced Software Architecture
</strong>Marwan Abu-Khalil was the presenter for this tutorial. This wasn't as hands on as I usually like from my tutorial sessions, but with that being said, there was a lot of good knowledge being tossed around.

We cover the best practices and outlined a rough path one should follow when designing software. Now it was mentioned frequently and often, that this was just the most common path encountered and that each project would lend itself to a different, there inherit lines the hard part of software architecture. If you could just put it in a patterns book, everyone would be good at it. The quote frequently used was "All architecture is design, but not all design is architecture."

<em>Brainstorm session instigated by this tutorial session.</em>
As a developer I myself tend to loose focus of the bigger picture as I dive deep in to the inner workings of some specific implementation or core sub-system. This course gives a nice high-level perspective of what the software architecture should focus on. For micro sized development teams; 1-5 developers, these things become even more important, since in most cases, every developer on a such a small team will be responsible for some of the most complicated areas of the system. This goes against the rule of thumb that architects, though they should be involved in the implementation, should not be involved in developing any of the core or complex systems of the architecture, so to prevent them from loosing focus in the details.

I agree with this, but as mentioned, in micro teams this can be very hard, if no impossible to do (1 man "team"). This is why introducing things like peer code review and daily standups are so important. Most people seem to have this idea that the smaller you are, the less you need to apply todays agile methods, on the countrary, staying agile with more developers as you can decouple subsystems and spread them across multiple developers or teams. Staying objective and keeping systems decoupled and preventing architectural drift in a one or two man team is even harder than say three, five man teams.

<strong>Pattern-Oriented Software Architecture
</strong>This tutorial was done by Doug Schmidt, side note, he's been living in Nashville the last few years doing his research and work out of Vanderbilt University.

This was a great tutorial. The subtitle was <em>A Pattern Language for Distributed Computing</em>. But it wasn't so much about completely new patterns, in fact any on fimilar with any of the GoF, PLOP, or POSA books would of received a lot of review. This was about using many proven patterns that we've used in stand-alone archictectures for a long time, take those and establish a pattern language for solving the problems we encoutned in todays distributed enviroments.

A pattern mentioned which I must of missed from the POSA 2 book, but new it immediately because I have implemented it under different names was the <a href="http://en.wikipedia.org/wiki/Active_Object">Active Object</a> pattern. Quickly, Active Object decouples the execution from the invokation of a method. Good coverage of other patterns as well. The handout includes pros and cons in a distributed enviroment for all the patterns presented.

I did take issue with some of the cons being things like "Harder to test" and "Harder to debug". I just kept thinking .. if you mock out the interactive components so that your tests are decoupled from any implementation, it seems no harder to test the Active Object pattern vs. any other piece of software. Questions like what if the request comes back out of order? What if the request processor goes offline? What do you do with the queue? What if you get a response for a request that is no longer valid? No more room in your queue? Etc, etc.. All of these conditions can and should be covered by tests. I don't have issues with testing or debuging my most recent Active Object implementation.

There was also a nice closing discussion about utilizing multi-core, embedded devices giving us a new reason to remember all the cycle and memory conservation techniques every said we could forget and if existing functional languages would be the wave of the future to take advantage of advancing core technology. Schmidt conclusion was we will need a new language or a dramatic extention to deal with these new concurrency issues ... I just kept thinking <a href="http://www.stackless.com/">Stackless</a>.

In the end, it was another standard issue Schmidt tutorial, it did not disappoint. Fast pace and lots of invited Q&amp;A and viewer interaction. Even if you don't like the guy or his ideas, it is worth it to see him give a talk at least once. Random side note .. he refered to Python once, following the words "novelty languages like..."

I didn't proof this at all, corrections welcomed.
