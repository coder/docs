---
title: Compute Resources
description: Learn the unique compute resource management capabilities in Coder.
---

Developer computing workloads are unique in that they don’t require consistent
access to CPU, instead they have short periods of peak usage during builds and
compilations, followed by long periods of relative idling.

Build and compilation performance directly impacts the development
experience of a project– faster builds mean faster iteration cycles,
leading to greater development velocity. But, traditional approaches to
providing developers with more hardware for computationally intensive
compilations leads to wasted resources and sunk costs.  

### With Expensive Laptops / Desktops

Consider the case where a team’s compilation is parallelizable up to 16 CPU
cores. To provide a more tolerable build time, each developer is given a 16
CPU core laptop. During builds, the machine sees 100% utilization. But, notice
how in a typical workday the machine is underutilized a vast majority
of the time. Only during the few minutes of compilation are the resources
utilized.

![resources-nonshared.svg](../assets/resources-old.svg)

### Shared Resources With Coder Workspaces on Your Cloud Infrastructure

This behavior enables a model of Shared Resources to provide developers access
to greater computing resources at similar or lower costs to the organization.
Consider the original example. Instead, let’s place every developer into an
isolated Coder Workspace on the same piece of hardware. Suppose this hardware
is a 16 CPU core machine. Notice how each developer has access to the proper
resources during peak load– providing a performant experience when needed,
with less waste when not.

<!-- Notice how each developer has access to greater
resources during peak load– providing a superior experience when needed,
with less waste when not. -->

![resources-shared.svg](../assets/resources-new.svg)
