---
Categories: ["python"]
date: "2013-07-14T12:15:00"
tags: ["python", "pyres", "pyramid"]
title: Pyramid Task Queue with pyres and redis
---

This is a story about Pyramid, pyres, some Python 3.3 porting, and just how easy it is to
get a task queue working with Pyramid and redis.

The story starts with John Anderson convincing me to work on notaliens.com. In the process of
developing the Sites portion of the project we decided we wanted to implement a task queue
for capturing, storing, and generating the thumbnails of the sites that are submitted
to notalienss.

After looking over a few choices, John had some previous experience with pyres at
SurveyMonkey so we pushed forward with that.

During the process of implementing the task queue we discovered that pyres wasn''t Python 3.3
compatible. As the flagship community site for the Pyramid project, we felt maintaining
Python 3.3 support was important.

So we had a choice, switch to an already Pyhton 3.3 compatible task queue
system or take on porting pyres to Python 3.3. We talked about some other options like
using celery or retools, but we decided we liked the API and the simplicity of pyres so much
that we could take on the porting effort.

Fortunately for us the pyres project had some great tests. This made the process of porting
pretty simple. You can actually see the diff for the pull request we submitted to pyres.


