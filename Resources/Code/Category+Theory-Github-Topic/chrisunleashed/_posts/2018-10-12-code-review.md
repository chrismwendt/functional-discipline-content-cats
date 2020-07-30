---
layout: post
title: "Code Review"
image: "assets/img/action-3644080_1280.jpg"
feature-img: "assets/img/action-3644080_1280.jpg"
tags: [programming, quality, code review]
---

**This is part of a series about developing your skills as a software developer. Code reviews are something that any organisation concerned with quality should encourage their developers to do. The following is the result from a discussion with my colleague Simon Forsberg who has for the past year been responsible as Sigma's Tomorrow Pilot for Clean Code and Code Review. For the curious check out [Sigma Tomorrow Pilot](http://www.sigmaitc.se/tomorrow-pilot)**

**What is a code review?**

A code review is an inspection of the code changes, normally in a commit or pull request. It is usually done one on one but it can sometimes be a good idea to involve more people as well.

**Why should we do code reviewing?**

There are at least two benefits to code reviews. The first one is to maintain a consistent level of quality, in which you should try and detect issues that automated static code analysis is not very good at finding. A good code review can help keep technical debt at a minimum. The second is knowledge sharing, every finding is a topic for discussion and has the potential for teaching both the person being reviewed and the reviewer.

**Who should do a code review?**

Everyone can review code! Both beginners and experienced programmers. While experienced programmers might think more about the overall architecture and how to reduce complexity, everyone can come with feedback regarding for example the readability of the code. Reviewing code is also a good way to develop yourself as a programmer.

**How should a proper code review be structured?**

It is a good idea to have a checklist ready before starting a code review, there are a lot of things to keep a look out for and you do not want to miss anything of importance. Preferably the change set should be as small as possible, this is related to the same reasons you want to keep your commits small. Which we discussed in [Mastering Git](https://chriskevin.github.io/chrisunleashed/2018/08/31/mastering-git.html). 
On a related note, Kent Beck wrote two interesting articles on the concepts of Limbo, which is basically taking small change sets to the extreme. See [Limbo: Scaling Software Collaboration - Kent Beck](https://medium.com/@kentbeck_7670/limbo-scaling-software-collaboration-afd4f00db4b) and [Limbo on the Cheap - Kent Beck](https://medium.com/@kentbeck_7670/limbo-on-the-cheap-e4cfae840330) for a more in depth elaboration.

Regardless of the size of the change set it is important that the person being reviewed explains the intent. Otherwise the reviewer might focus on just the quality. But good code is not very useful if it fails to do what it was intended for.

**What should you keep a look out for?**

Depending on the reviewers experience you can likely expect something between the following two levels. Since experience affects the quality of the review itself it is yet again a good idea to have a standardized checklist for your organisation so that you can judge when you might need a extra look from a more seasoned developer.

Basic level
* Is the code easily understandable?
* Is the code following standards and guidelines?
* Are classes/functions too complicated?
* Is the code easy to test and debug?
* Is there any duplication?

Expert level
* Is the code meeting non functional requirements?
    * Does the code have handle scalability?
    * Are there any security concerns?
    * Is the performance acceptable?
    * Is the code easy to maintain?
* Does the code align with the architecture?
* Is the code following Object Oriented Analysis & Design or Functional principles (depending on paradigm/language)?
* Are there any unresolved issues found by static code analysis?
* Is the coverage good enough?
* Is control flow and exception handling done in a clean way?
* Is logging done properly?
* Is there any potential for refactoring?
* Is the code's intent clear?
* Is the commit/pull request of good quality?

For more in depth elaborations on all these review subjects have a look at the following two articles [Code Review Checklist - To Perform Effective Code Reviews - Surender Reddy Gutha](https://www.evoketechnologies.com/blog/code-review-checklist-perform-effective-code-reviews/) and [What to look for in a code review - JetBrains](https://blog.jetbrains.com/upsource/2015/07/23/what-to-look-for-in-a-code-review/).

**What constructive feedback can I give?**

You can always give constructive feedback. If you cannot find any issues, then be nice and clear about that. If you think the code is good then praise the person that had written it.

**Are there any good tools that are helpful while doing a review?**

The most common tool is utilizing Pull Requests. Pull requests are made in such a way that somebody needs to review and approve the code before it can be merged. Be aware that pull requests are for merging branches and may therefore contain many commits. Huge pull requests have a tendency to be overlooked. If you are working trunk based and want to review at the commit level then [Gerrit](https://www.gerritcodereview.com/) is an alternate. [GitHub](https://github.com/) and [BitBucket](https://bitbucket.org/) also have great support for code review. You can review both commits and pull requests.

**Should code reviews only be conducted within an organisation or is it a good strategy to make code available for anyone to review?**

You should primarily focus on making code reviews routine within your organisation, mostly because of the risk that code may be sensitive or have licensing that prohibits it from being exposed to a third party. However if you have parts that are non sensitive and are under consideration for becoming open source then putting it on [Code Review StackExchange](https://codereview.stackexchange.com/help/on-topic) for example can be a good idea to get additional feedback. Keep in mind that any code published there falls under the Creative Commons Share-alike license. Another alternative is to hire a consultant with expertise in code quality, this can allow you to get an independent view on your overall coding while still adhering to licensing and sensitivity by requiring the consultant to sign a proper contract and with agreements.