---
categories: ["python", "brainstorm", "project"]
date: 2008/07/06 19:23:24
guid: http://pieceofpy.com/?p=74
permalink: http://pieceofpy.com/2008/07/06/project-developing-a-simple-insurance-interface/
tags: ["python", "project"]
title: 'Project: Developing a simple insurance interface.'
---
I play a game called <a href="http://eve-online.com">EVE Online</a> and I create and support a lot of software for our in-game corporation. After recently migrating forums away from punBB over to vBulletin I was stuck with the choice to either migrate our existing Ship Insurance script (written in PHP) or create a whole new system from scratch. Being a lover of Python, TDD, and sausage, I of course picked the rewrite option since it would be the most difficult and suck up more resources and time than just migrating some shitty PHP script.

The requirements are very simple.

Allow claim to be entered.
Allow claim to be approved.
Allow a claim to be denied.
Allow an agent to see a listing of all claims.
Allow filter options by ship type and pilot.
Allow agent to enter in the payout.
Save all past claim information. (reporting)
My personal goals for this project.

100% coverage with unittests.
Use TDD methods to develop the project.
Use the Trac system to support development.
Use Pylons with a SQLite DB
Use Ext for any fancy shit.

Code available soon as I get my repository back online.
