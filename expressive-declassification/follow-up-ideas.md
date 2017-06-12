# Follow up ideas for CCS resubmission of CSF paper

Reviewer comments addressed these core issues with our paper:

 - All reviews seemed to think that the idea of GUI based
   declassificiation was novel and worth exploring.  It seems to be an
   interesting insight.

 - There isn't a novel technical piece that the paper pointed out.
   The key novel things we propose from my perspective are:

    - The definition of GUI based declassification via the `level`
      function, which was clearly not presented as well as it could
      have: the most negative review seemed very certain that we were
      doing tagging, rather than declassification.  In fact our
      `level` function can be used for declassification and also
      labeling, and is a holistic framework that encompasses both
      things.
   
    - Our model of the Android semantics as a message queue.  This is
      novel, but as the reviewers point out, it's not subsequently
      used for anything.  The trace-based semantics is fairly standard
      from other work, so I'm not sure we can claim that as a real
      contribution

  - The way that we do symbolic execution is standard and doesn't
  present many useful insights.

  - It is unclear that our analysis can scale to real apps.  First, we
  tested it on small apps we wrote, and second there are problems
  inherent to symbolic execution.  An example is native code, but
  obviously that alone isn't a good reason to reject the paper since
  basically any static analysis would suffer this problem unless more
  advanced machinery were employed.

  - The statement about noninterference we provide is relative to
    traces of a certain depth, but it's not obvious it works for an
    arbitrary app.

I think that figuring out how to improve the work offers several
directions.  Some are simply improving these, and others offer more
interesting and novel things.

I outline some potential options I'm interested in exploring here:

  - Making the analysis complete.  Which is to say that our tool would
    err on the side of being too sound.  This could lead to
    interesting work because the way in which our GUI-based
    declassification policies interact with traditional program
    analysis mechanisms is something I think is interesting.  For
    example, we could use abstract interpretation to get a sound
    overapproximation for a class of our statements: but the trivial
    way to do this (I'm pretty sure) would say that everything on the
    message queue potentially happens in any interleaving, meaning
    that the LTL-ness of our policy semantics would be destroyed by
    this.  The interesting work here would be in figuring out how to
    use some program analysis that could handle our policies, and also
    work in a complete manner.

  - Focusing on working with arbitrary apps.  By this, I mean, could
    we figure out a way to take an app and add some instrumentation
    that logged the events, and also monitor flows of secret data, and
    have the user "evolve" a policy for the app based on their usage
    of an app, so that we could infer flows based on the user's input.
    The main research questions here are, how do we dynamically test
    "flows" of data, and how do

  - Ditch the idea of analyzing binaries, and try to have the
  *programmer* specify the policies as Java annotations to the source
  code.  The interesting thing here would be potentially in trying to
  figure out a simple user interface that the programmer could both
  easily use, that our analysis could ceritfy, and that the app *user*
  could understand.  The last point is interesting, and potentially
  hard to evaluate: I can imagine that explaining policies to users
  could be interesting but perhaps a road that might be hard to
  investigate?

  - Get a dynamic monitor to work on our binaries, and then use our
    certification to optimize it.  I've been talking to Jean Yang
    about working on faceted execution for Java, and I think that's a
    really cool idea.  The reason I like it is basically this:
    analyzing apps is hard, if your analysis mechanism falls down then
    you can fail to certify an app that needs to pass, or you can
    accidentally miss an app that is leaking information if your
    analysis is wrong.  Faceted execution is a way to add information
    flow control to the program by instrumenting it.  
    
    The "facets" are proxies that replace secret inputs, with pairs of
    <k : v_h, v_l>: a "high" view that private observers can see, and
    a "low" view that everyone else sees.  `k` is a principal (in some
    lattice) that is allowed to observe data.  For example, a secret
    contact would potentially be < user : "Alice", null >, meaning
    that if the user tried to "view" the contact, they would see
    "Alice," but everyone else would see null.  The semantics of the
    program is modified to propagate the facets.
    
    When you leak information to an observer, you project the facet in
    the right way.  For our purposes, the points of leakage could be
    things like writes to the network, sends to other apps via content
    providers, or writes to a disk, etc..  In those cases, we would
    take a faceted value and project based on who the user is: for
    example, in the following computation:

    x := secret_contact
    y := 0
    if (x == "Alice")
      y := 1
    send (net, y)
    
    the faceted semantics would execute the program with x = <user :
    "Alice", null>, and then y = 0, and then at the branch, y would be
    updated to <user : 1, 0>.  Note that this is *always* the case, no
    matter what the input value of `secret_contact` is by the
    definition of faceted semantics.  Then at the send, the network
    call would see the `net` is not allowed to see `user`, and the
    network would always see `0`.

    I would like to implement this for Android apps, for a few
    reasons:
    
    - Figuring out how to implement faceted semantics for a compiled
      language is an interesting research contribution in and of
      itself, the previous efforts have all worked for "toy"
      languages, or DSLs within other languages, where they make it
      easy.  I think this is a clear contribution that would work in
      concert with the other things our technique addresses.
    
    - Facets easily accomodate our declassification policies: after
      the declassification condition holds, you simply copy the data
      from the "public" view to the "private" view of the facet.

    - Once we have a faceted semantics, we can then *use* a program
      analysis to get rid of facets.  Trivially, if we had an oracle
      analysis that decided whether a program satisfied our policies,
      we could just remove *all* the facets in the program and execute
      it "normally."  Note that, values only become faceted once they
      are "tainted" by a secret value.

    - If you do analysis on a program with factes, you simplify a
      hyper-analysis (one that has to consider multiple paths) to a
      "regular" program analysis.  If we want to ask whether a program
      satisfies secure information flow, we just have to ask local
      facts about the facets in the program.  Then, we don't have to
      do a bunch of potentially elaborate techniques to consider pairs
      of program executions, and we can employ more standard program
      analyses.
    


