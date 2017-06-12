
Overall, I enjoyed reading the draft, and the flow you sell the story is
fairly good enough, except for that punch lines are not explicitly there in
the intro.  I'd like to recommend you to enumerate what the contributions of
this paper are and what readers can learn from reading this paper at the end
of intro, e.g., saying, we can truncate the location to a greater degree when
an app is measuring lower density objects, or some other things mentioned in
the result section.

In what follows, I'll list comments in order of their appearances in the
draft, which might be too minor (or already fixed).

* overprivilaged -> overprivileged

Fixed

* Kilometers vs. kilometers (also, Km vs. km as well as 50km vs. 50 km); use
* them consistently whatever is correct (or intended)

Standardized upon lowercase km (which is correct).

* [1][2][3][4][5][6] -> why not [1,2,3,4,5,6] ?

I'll check into this, I believe it requires changing TeX \cite rendering
options.  I'm sure Jeff knows.

* 816 apps?  If you count apps under market-2012-04-11, there should be 750
* apps (there are duplications due to symlinks).

Fixed, thanks!

* find-grained -> fine-grained

Fixed

* between two paras, one about location usage categories and the other about
* what you'll study, it'd be good to say something like, other categories are
* not suitable for location truncation.

It's not ncessarily true that they were not good candidates: some of the other
categories such as weather could have been.  We just choose to do lists.  But
I'll try to add some text.

* right below a standard approximation for longitude, Where -> where

Fixed.

* also, explanation about that approximation seems too simple.  Readers (like me) may feel foolish (yeah, I did :'( ...)

TODO: add text here.
*don*

Jeff: I'll just add a sentence or two on how / why approximation is necessary
and how it works?

* as shown in 1 -> as shown in Figure 1

Fixed, I think.  I fixed this a few days ago and can't find it in the paper
now.

* For me, content tagging or checkin seem equal to fine-grained targeted content in the sense that users who use both of them expect usage of exact location by those apps is somewhat legitimate.  In this regard, weather category is the same.  Since the paper emphasizes end user's perspectives, readers may have different criteria to categorize apps.  E.g., apps that can legitimately use user's exact locations, apps in which exact location is not necessary, etc.  Well, the problem is, according to such classification, the reason you chose the listing category is weakened (because that's no longer common use case).

I guess we should differentiate: fine grained is apps which will likely
malfunction with truncated inputs (navigation).  Tagging may be up to the
user: that's why we note it (and similar things that follow this pattern) and
explicitly do not test it.

* missing citation at the 2nd para in Section 4

*fixed*

* throughly -> thoroughly

fixed.

* ...but for purposes of our study there is no reason to (do so?)

Some apps use more elaborate mechanisms of checking whether location was
enabled.

*fixed*

* in Figure 4a. determined -> (wrong period there...?)

fixed

* in each app hat produced correct output. -> that

fixed.

* V.B.Edit distance, say why edit distance is five, e.g., because all items are different.



* Thus, we also explored using set intersection size as a metric: We ignore... -> either change : to . or We to we.

fixed.

* I simply disagree that the set intersection metric is fit for a common user task of checking nearby objects.  If I were to find McDonald's nearby, I'd rather search the keyword "McDonald's" on the Google Maps app directly, rather than using a restaurant finder app, which might show other irrelevant restaurants.  My point is, if a user decided to use that app, it may imply that he or she didn't have strong tastes at that moment.  So, simply, that's not a good example (to me at least).

Jeff gave this example: if you're in a town, and you are thinking of a
particular store nearby this metric would give the probability you'd find it.
But yes, I agree that you could just type it into google maps (assuming it
works with the same database).

* It was me who first used the name TroyD, but I'm not sure when we started to stick to the name Troyd.  Anyway, the TR uses Troyd, rather than TroyD, so for the sake of consistency, please use Troyd.  (Sorry for your inconvenience.)

I saw that, fixed.

* It's unclear why you used Troyd; you actually didn't emphasize Troyd's reusable scripts, which enable you to easily run apps with same scenarios under different truncations.

fixed.

* We developed a server that... resigns it with a shared user ID so that... -> this is actually Troyd's feature, not the server's, right?

fixed.

* For example, .... This meant TroyD had to expose... -> hmm, you just explained what Troyd did wrong, but didn't say what or how you corrected it.

fixed

* testint -> testing

fixed.

* In each subsection at Section VI, it'd be good to explain what is good and bad in graphs so that readers can understand general trends in graphs quickly.  E.g., at the graphs for first two metrics, going up is bad, but at the last metric, going down is bad.

Right!
*fixed*

* The caption in Figure 7 still mention dotted lines that represent cutoff, which seem to be moved to the other figure.

Fixed.

* Why Figure 7 and 9 (8 and 10) are not adjacent?

*fixed*

* Apps names are hard to distinguish, but I don't have a better solution/suggestion. :(

Fixed with different font

* TB Bank app -> TB ameritrade app (again, consistency)

fixed.

* According to overall discussions about results, you'd like to argue that set intersection is the most tolerable metric.  For me, however, additional distance seems better because apps have similar patterns without regards to cities.  (Maybe I'm wrong, though.)

I think you're right: additional distance is the better metric, because it's
more intuitive.

* Somewhere below Figure 7, para starting with "Each of the three metrics is..." is in the subsection C. Set Intersection.  All the paras below should be discussed in a separate subsection, say, D. Discussions?

*fixed*

* the order of discussion about three metrics didn't match the order they showed in the draft.  (Similar mismatch in the conclusion.)

* (the probability the user find a story they have in mind...) -> the users find...

* After discussing LPPM, you said, "Other policies from their system can be implemented within our framework as well."  What other policies?  How can you make sure?  Readers may be skeptical to see such single sentence without any more explanations.

TODO: discuss how CloakDroid fits in with LPPM

* user's simply install ClockDroid. -> oh, wait, install ClockDroid?  This reminded me that there wasn't any overview structure of ClockDroid.  I'm aware of Mr. Hide service and know that such service should be installed so as to provide strong security guarantee based on process isolation, but were these mentioned before?  These should be somehow aforementioned in Section 4.

*fixed*

