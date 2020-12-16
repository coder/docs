---
title: "Personalization"
---

Coder Enterprise allows you to personalize your environments to facilitate the
workflow that best works for you. This includes adding the tools that you want
that are not included in the default image from which your environment is
created.

There are two ways to personalize your environment:

- Using an [executable **~/personalize**
  file](https://help.coder.com/hc/en-us/articles/360057821653-The-Personalize-Script)
  that you've added to your **/home** directory
- Creating and linking a [source-controlled
  dotfiles](http://dotfiles.github.io/) repo

Regardless of which option you choose, storing your personalization settings
means you only have to define them once. They'll be implemented as part of the
Coder Enterprise environment build process without further action on your part.

## Home Persistence

All Coder Enterprise environments include a **/home** folder that's outside the
control of the image you used to create your environment. As such, any changes
that you make and want persisted must be saved in this directory. Anything in
this directory persists between rebuilding and updates, while anything _outside_
of this folder will be lost during a rebuild or update.
