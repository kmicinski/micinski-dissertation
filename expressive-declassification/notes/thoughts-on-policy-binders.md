# Thoughts on binders for GUI policies

## Simple example: declassifying public contacts

Consider the following example: we have a set of contacts, such as
    
	Bob, L
	Alice, H
	Jane, L
	Dave, H

The type of contacts are `string * P` where P is a policy variable:

    data P = H | L

We want to write a program that will send our public contacts to a
remote service (like Facebook), but *only* after we've pressed a
button that allows the program to release them.

We might write a program like this:

    \ contacts.
	  let bc = button<"Share contacts"> in
	  bc().
	    let public_contacts = filter is_public contacts
		net<public_contacts>

Here, the policy on `contacts` is the following:
    
	forall x : contact, bc : declassifiers.
	  G( ~K(x in contacts) U bc = ()
	      /\ K(x in contacts) -> public(x))

which means: for all contacts x, and all declassification channels,
the adversary never knows whether or not x is in the set of contacts
until bc = () (there is a technical point here, the button channel may
never go up to `()` based on user input, so we might instead use a
weak until depending on our temporal logic formalization).  It also
says that if an attacker *does* know that some contact x is in the set
of contacts, then that contact is a public contact.

## Question: can we create a channel type which corresponds to a declassifier

In the command:

	  let bc = button<"Share contacts"> in

We create a button, and the button construct returns us a channel.
The idea that I have is that events on this channel should correspond
to "licenses" to declassify the public contacts in x to the adversary.

In other words, we want the type of button to be:

    bc : (1 * \K. K u (filter public x)) stream

The way to read this is as follows: for each event on the channel bc,
bc generates two things: a unit value, and a license to transform the
attacker's knowledge from K (the initial knowledge), to K union
`filter public x`.

## Side diversion: what if contacts is a stream that changes over time

Let's say `contacts` is a channel that takes different values over
time.  We add a `when` predicate to stipulate that the channel take
some value at a certain time.

	forall x : contact, bc : declassifiers.
	  G(last(contacts) = cl -> 
	  G( ~K(x in last(contacts)) U bc = ()
	      /\ When(bc = ()

.... 

I am not sure where I'm going here and give up for now...

