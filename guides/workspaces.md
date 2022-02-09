---
title: "Workspace organization"
description: Learn how to organize your Coder workspaces.
---

This article walks you through considerations you should take when deciding how
to set up your Coder workspaces.

## One workspace per developer

With one workspace per developer, you can think of the Coder workspace the way
you would a laptop: the workspace is where you have all of your languages,
dependencies, and tooling installed, and it is the one place you'd go to work on
your projects.

## One workspace per project per developer

## One workspace per feature/branch/commit

In most cases, using one workspace per feature, branch, or commit will be an
overcommitment of resources. However, if the feature or branch is large enough,
this might be a viable solution.

That said, a single workspace for a commit is generally not the option that's
best in terms of optimal resource usage.

In general, we find that this is not the option that's best.

- One workspace per PR could be useful, with dev URLs replacing any existing
  preview builds

## Notes

My take: not sure about one-workspace per feature/commit. Seems kind of unnecessary.
However, I think having one workspace per PR would be neat. The workspace could
also replace any “previews” with dev URLs. Anyone could pop into an IDE, review,
view logs, or even push a fix to the branch without disrupting their workspace.

============

I'll answer by way of analogy. There are a lot of good ideas (e.g. 12-factor
stateless applications, serverless) that are great in principle, but difficult
for people to adopt. If you're a company that has invested a significant amount
in the way you work today, you can't just flip a switch and suddenly have
everything running on a serverless platform.

CloudFoundry was a Docker predecessor that pushed statelessness as a model, and
it was copying ideas from Heroku. These were great ideas that fit a specific
niche, in particular, companies that needed to run a lot of small one-off
applications. In contrast, Docker and Kubernetes were a lot more accessible to
people because the principles felt more similar.

"One-workspace-per-task" and ephemeral workspaces sounds good in theory, but you
run into problems just because people have not gotten used to the new paradigm.
My dotfiles are OK but I haven't spent too much time polishing them. But if
you're using throwaway workspaces, then you need them a lot more.

So in summary, my position is that these ideas are great, but difficult for
people to use in practice, which will hamper adoption. People always understand
things in the context of what came before ("horseless carriage", run stateful
applications in containers aka Kubernetes)... trying to jump too far ahead ends
up alienating a lot of customers

============

Yeah definitely in agreement that:

- it relies on extremely well-polished dotfiles repos
- it’s much easier to customize one (semi-ephemeral or non-ephemeral) workspace
than many. better for adoption if doesn’t require a huge paradigm-shift

============

It's interesting because there are several leverage points with different
benefits and drawbacks.

- 1 per user = laptop model more or less, the workspace is used for everything
- 1 per architecture = workspace for go and JavaScript project like coder and
  another workspace for the python ml project
- 1 per project = each project has a workspace. This may be 1-infinity
  repositories. Likely to be multiple architectures.
- 1 per major version of a project = when a project does a bunch of breaking
  changes and new golang or Java you make a new workspace. Coder can actually
  switch out the image under the workspace making this unnecessary, though it
  seems cool
- 1 per feature / pr ( / user) is how gitpod kinda suggests. You make a
  workspace to work on a feature branch and anyone who checks that out gets a
  pod designed for that branch. It'd be good if the storage situation was more
  flexible... at this point it's kinda frustrating.
- 1 per feature / pr (multi-user) would be a cool way to replace the preview app
  dynamic with a shared workspace that anyone can hop into and inspect or tweak
  the active code / branch and uncommitted configs and data stuff.
- 1 per push or commit is just excessive.

============

i’ve come across prospects who did not like this approach because they wanted to
use multiple IDEs in the same workspace, and they can’t do that with GitPod
certain parts of their project might be best edited in PyCharm, while others in
VS Code. it seems that our neutrality on this is a nice competitive advantage.

============
