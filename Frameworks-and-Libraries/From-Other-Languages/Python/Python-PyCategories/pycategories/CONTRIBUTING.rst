Contributing Guide
==================

Thanks for contributing to Pycategories!  This document will contain steps and guidelines for setting up a development environment and contributing to the project.

I use `OneFlow <https://www.endoflineblog.com/oneflow-a-git-branching-model-and-workflow#when-not-to-use-oneflow>`_ as the git workflow for this project.  Merge requests are rebased off of develop before merging in, and then fast-forward merged so there are no merge commits.  The develop branch is where all active development is done, and should be the source and target for new merge requests.  However, master is still the default branch for the repo, and its head will always point at the latest stable release tag.


Setting up a Dev Environment
----------------------------

Clone the repo and cd into the directory created for it.  Then run:

::

   pip install -e .[dev]

To run the tests and linting:

::

   python setup.py test
   flake8


Opening A Merge Request
-----------------------

Open an issue to describe the feature you want to add or the bug you want to fix, if there's not already an open issue for it.  This is an important step to prevent wasted time for everybody.  If its agreed that a fix or implementation of the issue will be accepted, continue to the merge request steps:

1. Fork the repo
2. Run the tests on your system before making any changes.
3. To work on your changes, create a branch off of the develop branch.  Develop is the branch where all active development is done; master is for tracking releases and only contains stable, released code.
4. Make your changes and add/update tests to cover them
5. Run the tests with ``python setup.py test`` and make sure they all pass and that coverage has not decreased.
6. Lint the code with the ``flake8`` command and make sure there are no violations
7. Open a merge request from your feature/bugfix branch into develop.  Please include an explanation of what the branch fixes or what features it adds, and how to use it.

After the merge request is open, the CI pipeline will run.  Any failures in it will need to be addressed.  Once the pipeline passes, the code will be reviewed and changes might be requested.  After those changes are made, if any, and the pipeline passes again, the branch will be merged into develop.


Code Style
----------

This project follows PEP8, with very few exceptions.  Line lengths should be limited to a max of 79, only exceeding that when doing otherwise would be extremely ugly or inconvenient.  Currently the only project-wide ignored rules in the flake8 config are these:

* E731 - assigning a lambda to a variable instead of using ``def``.  This is done all over the code base for small one-line functions
* W504 - line break after a binary operator
