# Todo list file

# Input equivalence 

Think about how the observer can see input sequences and how this
affects knowledge about the application's usage of those inputs.

# Notation

## Input channels

Need to add grammar to describe different types of channels:
 - Input
 - Output
 - Internal
 - Secret?

### Secret channels?

In the system where inputs are secret variables, we don't need secret
channels, because they're not time varying.  Instead, you just access
the variable.

In the system where you do have time varying secret variable, then you
*do* need secret channels, or something similar (like a stream or
something in the semantics to access them).

## 
