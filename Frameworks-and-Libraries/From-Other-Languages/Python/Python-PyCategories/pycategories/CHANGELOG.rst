Changelog
=========

This file tracks the notable changes to this project.  Its format is based on `Keep A Changelog`_

Unreleased
----------

This section tracks the changes currently on develop_ but not yet merged into master_ and tagged as a release.


1.2.0_ - 2019-06-24
-------------------

Added
+++++

* Bifunctor typeclass and defined instances of it for Either and Validation (thanks to `Daniel Vianna <https://gitlab.com/dmvianna>`_)
* ``categories.utils.id_`` to provide the identity function.  This is aliased as the ``unit`` function to maintain backwards-compatibility, but ``unit`` will be removed in a future version.
* Added ``either`` and ``maybe`` functions
* Added tests and documentation files to MANIFEST.in for package on PyPI

Changed
+++++++

* ``builtins.py`` to ``_builtins.py`` to avoid conflicting with Python's builtins module


1.1.0_ - 2018-11-15
-------------------

Added
+++++

* Improved `documentation <https://pycategories.readthedocs.io/en/latest/index.html>`_
* Semigroup (thanks to `Daniel Vianna <https://gitlab.com/dmvianna>`_)
* Validation semigroup, functor and applicative (thanks to `Daniel Vianna <https://gitlab.com/dmvianna>`_)
* Instances of semigroup for list, string, tuple, and Maybe (thanks to `Daniel Vianna <https://gitlab.com/dmvianna>`_)
* Ability to use functions as infix functions, with abbreviations for the longer function names
* ``match`` method for basic pattern-matching on Maybe, Either, and Validation


1.0.0_ - 2018-06-13
-------------------

The first major release, this added the core functionality of the library

Added
+++++

* Monoid
* Functor
* Applicative
* Monad
* Maybe monoid, functor, applicative, and monad
* Either functor, applicative, and monad
* Instances of monoid for list, string, and tuple
* Instances of functor for list, string, and tuple
* Instances of applicative for list and tuple
* Instances of monad for list and tuple
* Utility functions: compose, flip, and unit

.. _Keep A Changelog: https://keepachangelog.com/en/1.0.0/
.. _develop: https://gitlab.com/danielhones/pycategories/tree/develop
.. _master: https://gitlab.com/danielhones/pycategories/
.. _1.0.0: https://gitlab.com/danielhones/pycategories/tree/v1.0.0
.. _1.1.0: https://gitlab.com/danielhones/pycategories/tree/v1.1.0
.. _1.2.0: https://gitlab.com/danielhones/pycategories/tree/v1.2.0
