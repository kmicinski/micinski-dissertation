# Comments from Karla

1) At the end of section 2, you mention "an attacker"...  The first
section doesn't really talk much about an attacker, it just mentions
that location privacy is important.  Maybe a few more sentences
motivating the attacker/why i want location privacy would be helpful.
(But I'm not sure of what your target workshop is, so maybe this isnt'
necessary)

Okay, I will take this into consideration and see what text should be
added.

TODO: ask Jeff if I should write anything, then write a few sentences
on potential attacks, citing refs if necessary.

2) in section V on pg 5, you describe that "edit distance" is and what
"additional distance incurred" is....then there is a section on
testing infrastructure, etc....  then you come back to "edit distance"
in section VI...but at this point, I totally forgot what "edit
distance" is and had to jump back.  (same for additional distance).
Maybe reference back to it or reiterate the definition?

That's a good point.  Other people have mentioned a lack of continuity
in our discussion.  I will fix that as to reorganize things.

Added ref.

3) It would be cool if you were able to somehow get coordinates of the
places, store your own coordinate locally on your phone, and then
subtract the distance locally on your own phone to present the real
distance to the user, but I'm assuming the apps don't give you
coordinates for the places, just the raw distance value, right?

Right.  At one point we were going to try to use location names, then
in post processing mine Google maps data to get these numbers, but in
the end I didn't have time to write scripts to do this.

That actually would have been a cool idea: to insert a layer which got
the list of things, went out to Google maps, and then reorganized them
in the GUI. Wow, I should have really done *that*.  Then again, this
would be a very nontrivial rewriting, and requires a lot of static
analysis to do.  (And you'd have to show that the screen never did
something like read the UI and then send that to a web server or
something.)
