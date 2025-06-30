---
title: Tech debt is a poor name, use tax instead - here's why
tags:
  - opinion
  - lifecycle
date: 2025-07-01
slug: "2501"
summary: The word debt tells us nothing about what we’re supposed to do about it.
---

The term “tech debt” is not doing us engineers any favours. It is as ambiguous and misleading as the word “legacy”. Of course we can find definitions that state otherwise, but both sound like there was a mistake made, something preventable, as opposed to something _inevitable._ 

It also sounds like something _you_ created, instead of upfront investment _everyone_ needs to make to keep things running smoothly. Everyone wants to escape the negative vibe and ends up ignoring the only productive meaning of the word - that you’ve gotta pay it off. 
  
> Naming determines how people interact with the concept - if something is not a _bad_ thing, don’t use a negative noun/verb for describing it! 

The word _debt_ tells us nothing about what we’re supposed to _do_ about it. Every company, department, team ends up having the same discussions over and over again. Pay it off, but when, and what is the penalty for not paying it off? How can we communicate to our stakeholders that it will _never_ be paid off?

_Tax_ answers all these questions - we pay it off with _every_ ticket. Developers discuss the tax before the work starts and determine it based on the component and the changes made. For example

- active development, moving fast, haven’t seen the best structure yet? - low  tax, let’s keep rolling
- something with the component has caused trouble for a few iterations? last few sprints - raise the tax
- project has been on the shelf too long? - high tax. 
- the unit you’re supposed to change has zero unit tests? - high tax

Running from the inevitable just complicates things. When you include something in your routine, as opposed to asking for permission to do it _every single time_, everyone simply gets used to the fact that that’s how things are. No more hesitation and guilt preventing you from mentioning things that are necessary, and not your fault. And who knows, you might even have a glimpse of how build output looks without all the deprecation warnings.