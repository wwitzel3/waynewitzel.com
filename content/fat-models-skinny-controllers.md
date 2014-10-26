---
categories: ["python", "design", "pylons"]
date: 2008/10/05 10:00:15
guid: http://pieceofpy.com/?p=126
permalink: http://pieceofpy.com/2008/10/05/fat-models-skinny-controllers/
tags: ["python", "design", "pylons"]
title: Fat models, skinny controllers
---
In the world of MVC and RESTful services, the old addage fat models, skinny controllers is something I'm sure you've constantly seen and read about. So what does it really mean? How do you benefit? Is it the silver bullet for MVC development? What are the draw backs?

Using the latest versions of Pylons and SQLalchemy (0.9.7rc2 and 0.5.0rc1 respectivly) we can implement this methodology pretty easily. We'll use formencode schemas to handle the basic input validation and then keep our business logic in the controller itself.

Here is what a controller method using this concept might look like.

[sourcecode language='python']
class MemberController(BaseController):
    
    def __before__(self):
        if session.has_key('memberid'):
            c.memberid = session['memberid']
            
    @validate(schema=model.forms.schema.SubscriptionSchema(), form='new')
    def create(self):
        subscription = model.Subscription(c.memberid, **self.form_result)
        meta.Session.save(subscription)
        meta.Session.commit()
        return redirect_to(controller='member', action='account')
[/sourcecode]

The schema validation affords us the luxury of being able to just pass our data directly to the model. The __before__ method checks the session for the memberid assigned at login and gives us access to it, further keeping our method nice and clean. The model would implement the business logic, in this case since this is creating a new subscription, it would just sum now() and deltatime(days=days) to determine the expired.

This model could later be expanded upon, say for example you added an upgrade methods to your controller. Now, the same subscription model could be used with some added logic. The model could now have a static prorate method to expire the existing account and make room for creating the new subscription. I've pushed the example source to my github, hopefully this will get your brain juices flowing. If I get bored, I'll toss together a complete working example and check it in.

Source for this post can be found at
<a href="http://trac.pieceofpy.com/pieceofpy/browser/fat-models-skinny-controllers">http://trac.pieceofpy.com/pieceofpy/browser/fat-models-skinny-controllers</a>
