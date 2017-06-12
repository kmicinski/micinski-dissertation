# Contributions

## Proposed Results
- Edit distance does not work well for apps with high density inputs,
 and gives slightly disingenuous results (compared to intersection)

- For many apps with higher density inputs, the error could be skewed
  quite a bit with only small affects on app utility.

- Skewing app input data works better for lower density

- Applications are able to be fuzzed with little effect until they hit
some inflection point, after which they become useless very quickly.
	  
- Apps with a less dense distribution of points can have their inputs
fuzzed more gradually.

- Measured by the "additional distance" metric, app inputs can be
fuzzed (generally) to a large degree before becoming useless.

## Previously proposed results contributions

Jeff, I was flying back today, so I didn't see this email until a
while ago.

As far as I see it, the paper makes the following contributions.  I've
highlighted real contributions with (-) and perhaps less amazing
contributions with (+):

- We identify the problem of localization privacy: we want to minimize
  the probability that an attacker can --- at any given time ---
  figure out exactly where a user of an application is.

+ We give a summary of related work that introduces this goal: the
work on quantifying location privacy and optimal solutions for
location privacy offer attractive sounding goals but are abstract and
do not map practically to real apps.

- Instead, we present a classification of how apps use location, based
  on study of a corups of apps from the market studied in our previous
  work on binary rewriting.

  + We sort of do this right now, but maybe it's not clear.

+ We note that each of the papers on location privacy leaves open a
  concrete measure of utility for the app, or doesn't consider it at
  all.

- Using our rewriting system, we present a way to systematically skew
  location inputs to an app.

- We propose several metrics to quantify the utility of an app, given
  a skewed input, via a "detla function" over the GUI contents.

+ We note several issues that pop up in practice: ads do not vary with
changes in the input, for example.

- We identify a test suite which covers several variables, and provide
  a test framework for Android which can measure app GUI changes with
  changes in the input.

- We test our framework on several (currently: four) real world apps
  and show how our metrics correlate to real life use cases.

- To partially validate our results, we did a survey of several people
  in our lab to determine which metric they find most useful.  To do
  this, we collect screenshots from three or four real apps and show
  them the results under different metrics and let them choose.

(Or: we could set up an amazon mechanical turk account and crowdsource
this information...?)

This sounds good to me: which parts do you think should be emphasized,
and how can we make the paper do so?

Kris
