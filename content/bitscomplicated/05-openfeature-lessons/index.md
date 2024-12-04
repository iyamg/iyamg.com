---
title: What we can learn about software architecture from OpenFeature's design choices
tags:
  - intermediate
  - architecture
date: 2024-12-04
slug: "2405"
summary: tips for separating layers effectively and defining a robust interface
---
Platform Engineering Vienna had a wonderful meet-up at Dynatrace yesterday. Georg Pirklbauer gave a great overview of OpenTelemetry and Simon Shrottner introduced us to OpenFeature, a much needed project to standardise managing feature flags in applications. The features and versatility are impressive, and so many platforms and languages are already supported. I encourage you to check out the overview on the [website](https://openfeature.dev) yourself. Here, I point out some architectural principles without such ease of integrating and impressive tooling support might not have been possible.

## Overview of components

```typescript
OpenFeature.setProvider(new MyProvider())

const featureFlags = OpenFeature.getClient()
const withCows = await featureFlags.getBooleanValue("with-cows", false);
if (withCows) {
	res.send(cowsay.say({ text: "Hello, world!" }));
} else {
	res.send("Hello, world!")
}
```

{{< figure caption="source: [openfeature.com](openfeature.com)">}}

Here is how the specification separates the whole process (from the bottom up, simplified)

- **Flag Evaluation Backend** - this is where the flags are stored and evaluated, could be flagd or one of the many available cloud offerings. OpenFeature specifically sets the boundary here and remains backend agnostic
- **Providers** - responsible for performing flag evaluations. It abstracts away the underlying flag management system.
- **Evaluation API** - this is what _application authors_ interact with. You set a pre-defined or custom implemented provider which is then used to interact with the evaluation engine.

## The principles
### 1. When choosing layers, look for interchangeable parts to decide on boundaries
This approach can often provide you a fast and successful separation between your components. Think about different options the users would choose from - in this case, the would have different backends, and would need to utilise the sdk in various languages. Find the correct definition and the solution creates itself - evaluation backend and evaluation api should be decoupled, and in cases when one of the components is outside your boundary (you want to be backend agnostic, for example), introduce an *intermediate* layer that allows *anyone* to provide a backend to the sdk/api, and consume that provider in the sdk/api.

### 2. Be decisive and opinionated on the core, remain agnostic elsewhere
Just look at how simple OpenFeature's [provider interface](https://openfeature.dev/docs/reference/concepts/provider#dynamic-context-implementations-server-side-sdks) is. You cannot achieve such conciseness if you're not decisive. But there's more to the project than reading flag values, OpenFeature also enables powerful resolution, tracing and syncing capabilities. For this, three concepts - evaluation context, events, and hooks - are used. Read up on their definitions and you will see how simple, composable but strictly defined components can create robust but *manageable* systems.

### 3. A well designed interface enables well designed architecture
During first semester of school, most programmers are taught top-down and bottom-up problem-solving, and they are told that top-down will take a while to get used to, so don't worry about doing bottom-up for a bit. We should *really* be more precise with *for a bit* part, because many programmers seem to stretch its definition to mean years. And even then, it is often perceived only in the context of coding. If we agree that writing a top level function *first* enables better code, then there should be no ambiguity around the fact that *defining* the interface first enables better implementation. If you look at the code snippet with how OpenFeature sdk is used, the architecture they went for just *makes sense*. 

---

Hope you found this helpful! My upcoming post "The whys and hows of Test Driven Development" will talk more about the third point. I will consider making a newsletter soon, until then follow me on your preferred social network to get updates. Alternatively, you can make me very happy by dropping me an email at <bitscomplicated@iyamg.com> with some feedback.
