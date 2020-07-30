Quickstart
==========

Basics
------

You can get a lot done by just using the data types provided by Pycategories and the instances defined for some of Python's built-in types.  For example, the following example script uses ``Maybe`` to convert the contents of a file to uppercase and print the result, or exit with no output if the file doesn't exist.  This could be altered to use ``Either`` to display an error message instead of exiting with no output for non-existent files:

::

   from functools import partial
   import os
   import sys

   from categories import fmap
   from categories.maybe import Just, Nothing
   from categories.utils import compose


   def maybe_read_file(path):
       if os.path.exists(path):
           with open(path, 'r') as f:
               return Just(f.read())
       else:
           return Nothing()


   def upper_case_file(path):
       return fmap(lambda x: x.upper(),
                   maybe_read_file(path))


   if __name__ == '__main__':
       maybe_upper_case = compose(partial(fmap, print),
                                  upper_case_file)
       maybe_upper_case(sys.argv[1])


Each data type defines a new class to represent the type, and one or more data constructors that create and return objects of that type.  For example, the ``Maybe`` data type has two data constructors, ``Just`` and ``Nothing``.  To create a Maybe object, you would use one of those constructors:

::

   >>> Just(23)
   Just(23)
   >>> Nothing()
   Nothing

Data constructors are used just like Python functions.  If a data constructor takes no arguments, then you still need a set of parentheses after it, unlike in Haskell.  Even though the data constructor names are capitalized, like Python class names conventionally are, they are not currently implemented as separate classes, and are actually functions that return objects of the data type class.  This should be considered an implementation detail of the library and you should not rely on that behavior in your application code, since it may change in the future.

There is basic pattern matching available via the ``match()`` function on the data types provided by Pycategories.  This allows you to avoid doing manual checking of attributes of a data type.  Currently, the match function only matches on the data constructor, and not on value.  It takes a data constructor as an argument and returns a boolean indicating whether the object it was called on matches that constructor.  For example, reusing the ``maybe_read_file`` function in the previous example:

::

   data = maybe_read_file('/tmp/testfile.txt')

   if data.match(Just):
       print("The file existed and contained:\n\n{}".format(data.value))
   else:
       print("That file did not exist")


However, it is more common in functional programming to take the opposite approach and lift your normal functions into the context of a datatype using ``bind``, ``apply``, or ``fmap`` as appropriate, like the first example script does with fmap.


Defining Instances
------------------

A primary use of this library is defining typeclass instances for your own data types.  The Python module that defines each typeclass will have a function called ``instance``, which lets you define your own instances.  As an example, let's define monoid and functor instances for Python's built-in dictionary:

::

   >>> from categories import monoid, functor
   >>> monoid.instance(dict, lambda: {}, lambda a, b: dict(**a, **b))
   >>> functor.instance(dict, lambda f, xs: {k: f(v) for k, v in xs.items()})


Now that we've done that, we can call ``mappend`` and ``fmap`` on a dictionary:

::

   >>> from categories import fmap, mappend
   >>> test = mappend({'x': 'foobar'}, {'y': 'bazquux'})
   {'x': 'foobar', 'y': 'bazquux'}
   >>> fmap(lambda x: x.upper(), test)
   {'x': 'FOOBAR', 'y': 'BAZQUUX'}


To be truly useful, typeclass instances should obey certain laws that make them behave consistently.  To help test whether they conform to those laws, the typeclass modules have functions that return a boolean indicating whether the instance obeys the law.  To use them, you need to call them with some example values of the type you're testing; the specific arguments needed can be different for each law function.  The files in the `tests/ <https://gitlab.com/danielhones/pycategories/tree/master/tests>`_ directory have lots of examples of using those functions.  Here's a brief example testing the monoid and functor laws for dictionary:

::

   >>> monoid.identity_law({'a': 'test', 'b': 'other'})
   True
   >>> monoid.associativity_law({'a': 'test'}, {'b': 'other'}, {'c': 'something else'})
   True
   >>> functor.identity_law({'a': 'test', 'b': 'other'})
   True
   >>> f = lambda x: x.upper()
   >>> g = lambda y: y[0:3]
   >>> functor.composition_law(f, g, {'x': 'foobar', 'y': 'bazquux'})
   True

For details on what each typeclass needs when defining instances, refer to the `API <api.html>`_ documentation.
