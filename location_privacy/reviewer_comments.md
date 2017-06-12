----------------------- REVIEW 1 ---------------------
PAPER: 19
TITLE: An Empirical Study of Location Truncation on Android
AUTHORS: Kristopher Micinski, Philip Phelps and Jeffrey Foster

OVERALL EVALUATION: 1 (weak accept)
REVIEWER'S CONFIDENCE: 4 (high)

----------- REVIEW ----------- 

The authors seek to understand the impact of location truncation on
various location-based services.  Several metrics are used to attempt
to measure the effect on truncation on the applications.  They
surveyed the use of location, categorizing the uses of location
(fine-grained, adds, content tagging / check-in, nearest city, etc.).
One of the discoveries they made is that the density of the objects of
matters in whether location truncation is feasible as a
privacy-enhancing mechanism.

Some of the conclusions are not surprising, including object density.

One of the implications of this work is that permissions for location
are currently too coarse (no pun intended).  And that location
coarseness perhaps should be tied to geographies, perhaps as defined
by the cellular services provider (assuming that the device has
cellular service enabled).

The results here are useful in that location truncation is not a
terribly useful concept in general as a privacy enhancing technique at
this time.  It is dependent on the needs of the application, as well
as the density of the objects of interest.  These are hard to
automatically determine (object density), nor do typical device users
understand the subtleties of application permissions.  Right now,
given the state of the art, these factors make it difficult to
automatically enforce by a platform (e.g., Android).

> TODO: I don't think this review solicits any specific changes to the
> paper.  I'll keep thinking.

----------------------- REVIEW 2 ---------------------
PAPER: 19
TITLE: An Empirical Study of Location Truncation on Android
AUTHORS: Kristopher Micinski, Philip Phelps and Jeffrey Foster

OVERALL EVALUATION: 2 (accept)
REVIEWER'S CONFIDENCE: 4 (high)

----------- REVIEW -----------
[Summary]

This paper investigates how location truncation impacts the usefulness
of Android apps. They test 6 apps out of the most popular apps in
Google Play whose primary purpose is to show nearby objects.

The authors use Dr. Android and Mr. Hide to replace all calls to the
LocationManager in each app to their custom LocationManager that
allows them to intercept and modify the location information returned
by the OS before it is given to the app.

They choose six cities with varying sizes and populations (Fig3) to be
the source for the location tests and 10 random geographic points
within each city are given to the apps. For each point in each of the
cities the apps are run and the first 4 pages (20 items) each app
recommends are recorded for each of 10 levels of truncation from 0km,
0.1km... 50km. Three metrics are used to measure the impact of
truncation (each comparing with the non-truncated list): edit
distance, set intersection size, and the additional distance required
to reach the first item.

Findings:
- Location can often be significantly truncated without harming the
  utility of the app: up to 20km when an app is used in a lower
  population area and usually at least 5km in more populated areas.

- Apps have relatively little change in utility up to a certain amount
  of truncation, typically ~5km.

- The factor that most determines the ability to truncate location was
  the density of the set of locations the app computes over. (e.g. if
  there are many restaurants around you truncation will affect the
  list much more than if you are in a remote location looking for a
  hospital)
  
  [Strengths]

  Though several other works have researched improving location
  privacy on smartphones, this is the first work that gives insight
  into how the usefulness of apps degrade when these privacy measures
  are implemented. This is crucial for understanding the practical
  usability of these solutions for real users. Personally, I have
  wondered how location truncation impacts usability and it's nice to
  see the issue being explored.
  
  I think the methodology and metrics used make sense and the
  evaluation is executed well.
  
  [Weaknesses]

  Besides automating so many Android app runs, the methodology work
  does not seem to be very challenging.
  
  The authors chose to evaluate 6 out of the 43 apps whose purpose is
  to "list nearby objects." They do not spend much time justifying why
  they chose just 6 apps or why those apps specifically. I agree that
  they chose apps that search for fairly different objects, I'm just
  curious what other apps were skipped. 10 would have been a more even
  number and would lend a little more credence to the results, though
  the results are intuitive and probably wouldn't change significantly
  with more apps studied. To be fair, they did test apps on 60
  locations at 10 levels of truncation, so each app added would cause
  an additional 600 runs.
  
> The real methodology behind picking which apps was to find apps
> which covered a distribution of use cases, and also (easily) worked
> with minimal updates to Dr. Android and Mr. Hide.  Because those
> tools are both becoming dated with respect to the Android API (and
> because real apps use elaborate mechanisms to check if the
> permisison is enabled), making real apps work is hard and we picked
> apps which were easily able to use the tools.  
>
> TODO: I should talk with Jeff and decide if it's worth investing the
> time to do additional experiments.

  [Assorted Feedback]

  The paper describes the hardware they used but not how long it
  took. I'd be interested in a total time and an average time per run
  of an app.
  
> TODO: Discuss with Jeff if this is worth incorporating into the
> paper.  To give a rough answer, each app took around 1-3 minutes per
> run (mostly because emulators are slow and black box testing means
> that we are going through a lot of context switching to push buttons
> on the apps and gather results).
> Update: Put this in the paper, added a sentence explaining how long
> each emulator run took.

  Averaging distance incurred over the first 4-5 items might make more
  sense, as just the first item could potentially vary frequently (as
  edit distance showed specific ordering tended to vary).
  
  I'm not sure why the Results section is ordered Edit/Additional/Set
  difference when in IVB you introduce the metrics in the order
  Edit/Set/Additional. I believe you changed the order in Results so
  it would be least -> most permissive of truncation. I feel the flow
  of the paper would be best if you either kept the same order or made
  it more clear at the beginning of Results that you were changing the
  order and why.

> This is probably my mistake.  I think at the last minute I reordered
> things and checked that they were presented consistently, but
> ultimatley did not clean up text in this way.  I will check this
> section to ensure consistency in the submitted manuscript.
> Update: I rearranged the results section to go Edit distance, Set
> Intersection, and Additional distance.  

  Spelling: "Hospitlals"

> TODL: Will fix.
> Fixed.

  [Final Thoughts]

  I think this is good work. They investigate a previously unaddressed
  (to my knowledge) issue- how location privacy impacts the utility of
  apps. The methodology is appropriate and the findings are
  interesting though not unexpected. The effort required to do so many
  runs of the apps is clearly non-trivial.
    
  ----------------------- REVIEW 3 ---------------------
  PAPER: 19
  TITLE: An Empirical Study of Location Truncation on Android
  AUTHORS: Kristopher Micinski, Philip Phelps and Jeffrey Foster
  
  OVERALL EVALUATION: 2 (accept)
  REVIEWER'S CONFIDENCE: 3 (medium)
  
  ----------- REVIEW -----------

  This is a nice piece of work, exploring the effectiveness of
  quantizing location information (to protect location privacy)
  for a subclass of location-using mobile apps.  The work is
  well executed and of high technical quality.  This should help
  us better understand the feasibility and effectiveness of this
  possible defense.
  
  The primary weakness of the work is that it only looks at 6
  apps.  That's a fairly small sample size.  The biggest thing
  that the authors could do to strengthen the paper before
  publication is to increase the number of apps.  I know that it
  takes some work, but now that you've built the infrastructure,
  I think it would be worthwhile, in terms of your long-term
  impact on the field.  (I know that this extra work won't be
  necessary, for purposes of getting the paper accepted at MoST:
  but I encourage you to do the work all the same, as I think it
  will make a significant difference in the intellectual impact
  of this work on other researchers who work in this area.)
  
> TODO: talk to Jeff about weighing the pros / cons of taking more
> time to make more apps work and test them, versus leaving it at
> current number.
  
  Other minor comments:
  
  Figure 1: It could be clearer what the columns are.
  The left column is the number of apps that use location
  for the named purpose and for ads?  What's the right
  column?  Is it the number that use location for the named
  purpose regardless of whether it uses ads or not?  It would
  help to state this explicitly (the figure caption would be
  a good spot).  Are there any apps that use location for
  multiple non-ad purposes?
  
> There may be one or two apps that use location for multiple non-ad
> purposes.  I will compile a list of these and incorporate them into
> the paper text.  I will also make more explicit what the reviewer
> was suggesting.

  Figure 1: I found this surprising.  This suggests that the
  overwhelming majority of apps you studied don't use ads?
  That feels wrong.  Other research has found that many/most
  apps are ad-supported.  I suggest you double-check your
  analysis, and if you still believe it is correct, include
  some explanation in the body of the paper about what's going
  on here and why the numbers are counter-intuitive.
  
> This is the revier's misunderstanding because of poor wording in the
> paper.  The results indicate which portion of the apps *using
> location* use it only for ads: not that ads are *included* in the
> app.  TODO: revise the paper to address and clarify this comment.
> Update: fixed.

  II: "will have essentially no effect" - add "on their
  utility" (it will have an effect on their privacy impact)
  
  There's some typo in how footnote is referenced: it shows
  up as ". 1."
  
  Latex: Use \cos \phi, not cos \phi.  Same for \sin.

> Todo: fix this.
> Update: fixed.

  V: "We also found that apps have relatively little change
  in utility ... 5 km": That's not how I read the graphs.
  I see evidence of significant change in utility at 5km.
  It looks to me like 1km would be a more reasonable number
  to use here.

> Todo: review statements to ensure that this is accurate.
  
  It might not hurt to mention, cite, and compare to AppFence
  (Hornyack et al, CCS 2011).

> I know of AppFence, but not how it specifically applies to location.
> (In the same way that many other broad Android security systems can
> be applied to location, such as CRePEDroid.) However, since the
> reviewer mentioned it I will reread it and incorporate it into the
> related work section.
> Update: included information
