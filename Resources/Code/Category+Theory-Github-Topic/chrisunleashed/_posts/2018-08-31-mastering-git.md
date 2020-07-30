---
layout: post
title: "Mastering Git"
image: "assets/img/git_1600.png"
feature-img: "assets/img/git_1600.png"
heading-dark: true
tags: [tools, version handling]
---

**This is part of a series about developing your skills as a software developer. We use different tools on a daily basis and one of the most frequently used is Git. Usually we just care about its version handling capabilities, however there is so much more value that we could get from the tool by just being a bit more mindful of how we use it.**

**How do you attain a clean and useful commit log?**

To be able to make good use of `git blame` och `git log` then it is important to write good commit messages. Chris Beam talks about The seven rules of a great Git commit message, which are still as relevant today as when they were first conceived, [How to Write a Git Commit Message - Chris Beam](https://chris.beams.io/posts/git-commit/). But it is not enough just to write good commit messages, you also need to work with small commits.

**Why should you do several smaller commits?**

The purpose of each commit becomes clearer when it focuses on a specific addition/change/delete. Commands such as `git log` and `git shortlog` become a lot more useful and the same goes for debugging when a bug is accidentally introduced.

**Should I mix formatting and style changes together with code changes?**

No, you should keep formatting and style changes to a separate commit to make the intent and purpose clear.

**How can I use Git for debugging?**

You can use `git blame`, `git bisect` or `git grep` depending on how much information you have related to the bug. Read [Debugging with Git - Kristina Pomorisac](https://dzone.com/articles/debugging-with-git) for more details.

**How can I use the commit history to find useful information?**

`git log` and `git shortlog` are really powerful commands. They have tons of filters to help you extract the information that you want. John Kagga explores the most useful use cases in his article [Exploring the Git log command – The Andela Way - John Kagga](https://medium.com/the-andela-way/exploring-the-git-log-command-9117b9ff3c2c).

**How do I pick the best suited branch strategy?**

Picking the right branch strategy is mostly up to how your team wants to work. The general advice is to avoid deeply nested branches, also nested branches should have a short lifespan to avoid horrific merges. Atlassian have some good comparisons between strategies [Comparing Workflows](https://www.atlassian.com/git/tutorials/comparing-workflows). Trunk based workflow is also an interesting alternative. Take a look at [What Are the Pros and Cons of Using a Trunk-based VS. Feature-based Workflow - Stackoverflow](https://stackoverflow.com/questions/42135533/what-are-the-pros-and-cons-of-using-a-trunk-based-vs-feature-based-workflow-in-g) for a discussion.

**When should I merge and rebase?**

Use rebase to get changes from the top of the hierarchy and merge when you want to move your changes back to the top. By rebasing into your feature branch you can avoid unnecessary merge commits. And when your branch is synched with the branch that you want to merge into then a fast-forward merge is done, which does not produce merge commits either. Derek Gourlay explains all of this in more detail [Git - When to Merge vs. When to Rebase - Derek Gourlay](https://www.derekgourlay.com/blog/git-when-to-merge-vs-when-to-rebase/)

**When is it appropriate to squash my commits?**

If you have WIP commits or small fixes like misspelling etc. then it is a good idea to squash them together to form one commit. But as stated earlier about keeping commits clean it is important that each commit still has a clear intent. If squashing produces a single commit that is still understandable without an elaborate description, then by all means squash. Steven Schwenke elaborates more on this in [Git: To Squash or Not to Squash? - Steven Schwenke](https://dzone.com/articles/git-to-squash-or-not-to-squash).

[//]: # (**When should I use cherry-pick?**)

[//]: # (**How do I undo a commit?**)

[//]: # (**How do you undo a push?**)

**When should I tag my commits?**

Tags should be used to mark up special commits, usually to indicate a new version. [Semantic Versioning](https://semver.org/) and [Compatible Versioning](https://github.com/staltz/comver) are two good schemes to follow. This makes it easy to find a specific point and maintain a changelog with all features up until that point. Version tagging is also better to automate in your CI pipeline by reading from one of your manifests. Whether it being Maven pom.xml, Gradle build.gradle or npm package.json. The good thing with tags is that they are also easy to create/update/delete retroactively.

**Why should I keep my stash and local branches tidy?**

In the beginning you might not think much about what you put in your stash or the branches that you checkout. However it does not take long until you will be overrun with a long list of discarded stuff. Run `git stash list` to see your entire stash. If you use `git stash pop` a lot then you might have a pretty clean list. However if you use `git stash apply` then stash will not be removed. It is easy to clean your stash with either `git stash clear` if you want to get rid of everything or `git stash drop` for a specific stash.

**What are the most useful Git Hooks?**

You should run your local testing on a `pre-commit` hook. I know some people would argue that this is annoying and want to do it on `pre-push` only. However there are some good points to why you should do it for every commit. The first one is when you are working trunk based, then waiting until push is too late. In this case each and every commit should be stable and production ready so that your team mates can review and ok it. The second point is that if you get code style and test errors at push then you need to create another commit to add those. Then you should squash that commit together with the one(s) you were trying to push. So basically you just added more manual steps when you could have had a closer feedback loop and fixed the problems early.

It is also nice to add some visual feedback to the current state after a commit. I usually add `git status` to my `post-commit` hook. I also got a tip from [Simon Forsberg](https://codereview.stackexchange.com/users/31562/simon-forsberg?tab=profile), `git log --branches --decorate --graph --oneline --all`. This visualizes a graph of commits from all branches together with commit hash and a short log message.

**Conclusion**

When you start looking into Git in depth, then you realize that there is a lot more to it than expected. I think that I have managed to highlight and answer many useful questions. In all likelihood I will get back to this article as soon as I have learned more and update it with some more good questions and answers. In the meantime you should take a look at the misc resources that I discovered while researching. There is a good take away from all of them.

**Miscellaneous tips**

The most comprehensive resources can be found at [https://github.com/git-tips/tips](https://github.com/git-tips/tips) and [Oh shit, git!](http://ohshitgit.com/) (perfect for those situations when you know you messed up). If you want in depth knowledge then the official [Git Book](https://git-scm.com/book/en/v2) is still your best read.

* [Mind Your Git Manners - Kevin Liddle](https://8thlight.com/blog/kevin-liddle/2012/09/27/mind-your-git-manners.html)
* [GitHub Community Guidelines](https://help.github.com/articles/github-community-guidelines/)
* [Git Stats — Cool Visualisations For Local Git Statistics With Contribution Calendars](https://fossbytes.com/git-stats-git-visualization/)
* [Git Out of Trouble](https://cdemyanovich.github.io/git_out_of_trouble/)
* [Git Best Practices - Seth Robertson](https://sethrobertson.github.io/GitBestPractices/)
* [Git Immersion](http://gitimmersion.com/) - Great step by step training for different commands and scenarios
* [Gerrit Code Review](https://www.gerritcodereview.com/) - Code review tool.
* [GVFS](https://gvfs.io/) - Microsoft took Git one step further.