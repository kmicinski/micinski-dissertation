# Todo

## Resize app screenshots

## Jeff's comments from figures
*done*

Figure 5 - "Edit distance" is cut off on the left margin
Figures 5, 6, and 7 - change the x-axes to be in km rather than m
Figures 5, 6, and 7 - change the x-axis caption to be "Location truncation (km)"
Figure 6 - change  y-axis Km to be "km"
FIgure 7 - "Set intersection size" is cut off on the left margin

## Fix tables of apps

Given symlinks in market pull.  Rerun scripts.  Paper inlines table,
so put in again, then patch up number from old table to match new
ones.

## Responses from readers (2/26/2013)
*addressed*

- Iulian:

 + Small comments on edits, fixed all of them.
 + Consider adding a paragraph on what a list is in our context.
 + Consider adding explanation on high level structure of how our location 
 service works
 + Change font for apps to different than regular font.

## For 2/18/2013

- I checked out a bunch of alternative way to calculte second
  derivative reliably.  I found an R package which allows calculation
  of second derivative via cubic splines, but I couldn't really get it
  to work and don't fully understand it, so it's out.

- I haven't put a table of of knees in the paper, that needs to be
  done.

- I still haven't taken a look at what's happening with the hospitals
  app, I'm going to take this out before noon tomorrow so the data
  will be consistent.

## From 2/17/2013

- Investigate what's happening in the restaurant finder app, things
  seem to be there in teh scripts, but calculations aren't right.

- Something is messing up the calculation of the additional distance
  metric at 50Km.  I spot checked a bunch of other calculations and
  they seemed correct, so I'm not sure what's hapening

- Insert figures of apps showing how they work.

- Explain that location skewing isn't pointless because when the user
  asks directions for the result they go to a different app.


