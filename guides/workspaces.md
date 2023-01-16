# Workspace organization

This article describes considerations for deciding how to set up your Coder
workspaces.

In general, the fewer workspaces per developer, the easier it is for the
individual developer to manage. However, the complexity of the underlying images
increases as the images need to support multiple projects, each potentially with
its own language, set of tooling, and dependencies.

Nevertheless, for teams that do not have a complex development workflow, we
recommend starting with one workspace per developer, since it is the fastest,
most straightforward model to adopt.

## One workspace per developer

With one workspace per developer, you can think of the Coder workspace the way
you would a laptop: the workspace is where you have all of your languages,
dependencies, and tooling installed, and it is the one place you'd go to work on
your projects.

Benefits:

- Fewer workspaces to manage
- No need to switch between workspaces for different projects

Potential caveats:

- The size of the workspace can grow quite large
- The image supporting such a workspace can become complex

## One workspace per architecture

In this situation, you would create one workspace for your JavaScript projects,
one workspace for your Python projects, and so on.

Benefits:

- Smaller images, since they only contain one language and its dependencies

Potential caveats:

- Developers may have multiple workspaces, consuming more storage space overall

## One workspace per project per developer

Each developer has multiple workspaces, with each workspace devoted to one
project. If a developer is currently working on three projects, they'd have
three workspaces.

Benefits:

- Streamlined images with only the languages and dependencies included
- Smaller, lighter workspaces

Potential caveats:

- As the number of workspaces per developer grows, the importance of
  well-defined dotfiles grow to ensure that developers do not spend too much
  time personalizing their workspaces

### One workspace per major version of the project

A subset of this category is one workspace per **major** version of a project
(e.g., making major, breaking changes to something). Furthermore, Coder allows
you to change the underlying image, so you can update the image (changing out
the language and any dependencies) if needed.

The benefits and potential caveats of this option are similar to those involved
with setting up one workspace per project per developer.

## One workspace per feature/branch

Setting up one workspace per feature (or branch) allows your developers to focus
only on that feature.

With dev URLs, allowing access to the work in progress, the workspace could also
replace the need for any preview builds, while also providing access to some of
the logs. Reviewers or other developers could push changes to the branch/pull
request from their own workspaces without needing access to the primary
developers' workspaces.

## One workspace per commit

We do not recommend creating workspaces on a per-commit basis due to the high
cost of resources in these situations.
