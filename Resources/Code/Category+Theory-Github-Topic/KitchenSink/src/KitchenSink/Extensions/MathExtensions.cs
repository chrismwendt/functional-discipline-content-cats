﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using static KitchenSink.Operators;

namespace KitchenSink.Extensions
{
    public static class MathExtensions
    {
        public static bool IsReal(this double x) => Not(x.IsNotReal());

        public static bool IsNotReal(this double x) => double.IsInfinity(x) || double.IsNaN(x);

        public static bool IsEven(this int x) => (x & 1) == 0;

        public static bool IsOdd(this int x) => (x & 1) != 0;

        public static bool IsDivisibleBy(this int x, int y) => x % y == 0;

        public static bool IsNotDivisibleBy(this int x, int y) => x % y != 0;

        /// <summary>
        /// Returns first value, but no less than the second.
        /// </summary>
        public static A NoLessThan<A>(this A x, A min) where A : IComparable<A> => x.CompareTo(min) < 0 ? min : x;

        /// <summary>
        /// Returns first value, but no more than the second.
        /// </summary>
        public static A NoMoreThan<A>(this A x, A max) where A : IComparable<A> => x.CompareTo(max) > 0 ? max : x;

        /// <summary>
        /// Returns first value, but no less than the second.
        /// </summary>
        public static Func<A, A> NoLessThan<A>(this A x) where A : IComparable<A> => min => x.NoLessThan(min);

        /// <summary>
        /// Returns first value, but no more than the second.
        /// </summary>
        public static Func<A, A> NoMoreThan<A>(this A x) where A : IComparable<A> => max => x.NoMoreThan(max);

        /// <summary>
        /// Returns greater value, defaulting to the first.
        /// </summary>
        public static A Max<A>(this IComparer<A> comparer, A x, A y) => comparer.Compare(x, y) > 0 ? x : y;

        /// <summary>
        /// Returns lesser value, defaulting to the first.
        /// </summary>
        public static A Min<A>(this IComparer<A> comparer, A x, A y) => comparer.Compare(x, y) < 0 ? x : y;

        /// <summary>
        /// Inclusive on start value, exclusive on end value.
        /// </summary>
        public static IReadOnlyList<int> To(this int start, int end) => new RangeList(start, end - 1);

        /// <summary>
        /// Inclusive on start and end value.
        /// </summary>
        public static IReadOnlyList<int> ToIncluding(this int start, int end) => new RangeList(start, end);

        private class RangeList : IReadOnlyList<int>
        {
            private readonly int start;
            private readonly int endInclusive;

            public RangeList(int start, int endInclusive)
            {
                this.start = start;
                this.endInclusive = endInclusive;
            }

            public int this[int index] => start + index;

            public int Count => endInclusive - start + 1;

            public IEnumerator<int> GetEnumerator()
            {
                var i = start;

                while (start <= Cmp(i) <= endInclusive)
                {
                    yield return i++;
                }
            }

            IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
        }

        public static int Factorial(this int n)
        {
            if (n < 0)
            {
                throw new ArgumentException("Factorial not valid on integers less than 0");
            }

            if (n == 0 || n == 1)
            {
                return 1;
            }

            var result = 2;

            for (var i = 3; i <= n; ++i)
            {
                result *= i;
            }

            return result;
        }

        public static int Permutations(this int n, int r)
        {
            if (n < 0)
            {
                throw new ArgumentException("Permutations not valid on negative set sizes (n)");
            }

            if (r < 0)
            {
                throw new ArgumentException("Permutations not valid on negative set sizes (r)");
            }

            if (r > n)
            {
                throw new ArgumentException("Permutations not valid on take sizes greater than set sizes");
            }

            if (r == 0)
            {
                return 1;
            }

            if (n == r)
            {
                return Factorial(n);
            }

            var result = 1;

            for (var i = n - r + 1; i <= n; ++i)
            {
                result *= i;
            }

            return result;
        }

        public static IEnumerable<IEnumerable<A>> Permutations<A>(this IEnumerable<A> seq, int r)
        {
            var array = seq.ToArray();
            var len = array.Length;

            if (r > len)
            {
                throw new ArgumentException("Can't take subsequence longer than entire set");
            }

            if (r == 0 || len == 0)
            {
                yield break;
            }

            if (r == 1)
            {
                foreach (var item in array)
                {
                    yield return SeqOf(item);
                }

                yield break;
            }

            foreach (var i in Enumerable.Range(0, array.Length))
            {
                var sublist = array.ExceptAt(i);

                foreach (var subseq in Permutations(sublist, r - 1))
                {
                    yield return SeqOf(array[i]).Concat(subseq);
                }
            }
        }

        public static int Combinations(this int n, int r)
        {
            if (n < 0)
            {
                throw new ArgumentException("Combinations not valid on negative set sizes (n)");
            }

            if (r < 0)
            {
                throw new ArgumentException("Combinations not valid on negative set sizes (r)");
            }

            if (r > n)
            {
                throw new ArgumentException("Combinations not valid on take sizes greater than set sizes");
            }

            if (r == 0 || n == r)
            {
                return 1;
            }

            var result = 1;

            for (var i = n - r + 1; i <= n; ++i)
            {
                result *= i;
            }

            for (var i = 2; i <= r; ++i)
            {
                result /= i;
            }

            return result;
        }

        public static IEnumerable<IEnumerable<A>> Combinations<A>(this IEnumerable<A> seq, int r)
        {
            if (seq == null)
            {
                throw new ArgumentNullException();
            }

            if (r < 0)
            {
                throw new ArgumentException();
            }

            var array = seq.ToArray();
            return CombHelper(array.Length, r).Select(ZipWhere(array));
        }

        private static IEnumerable<IEnumerable<bool>> CombHelper(int n, int r)
        {
            if (n == 0 && r == 0)
            {
                yield return EmptyBoolSeq;
                yield break;
            }

            if (n < r)
            {
                yield break;
            }

            if (r > 0)
            {
                foreach (var subGroup in CombHelper(n - 1, r - 1))
                {
                    yield return OneTrue.Concat(subGroup);
                }
            }

            foreach (var subGroup in CombHelper(n - 1, r))
            {
                yield return OneFalse.Concat(subGroup);
            }
        }

        private static readonly IEnumerable<bool> OneTrue = SeqOf(true);
        private static readonly IEnumerable<bool> OneFalse = SeqOf(false);
        private static readonly IEnumerable<bool> EmptyBoolSeq = SeqOf<bool>();

        private static Func<IEnumerable<bool>, IEnumerable<A>> ZipWhere<A>(IEnumerable<A> seq) =>
            selectors => seq.ZipTuples(selectors).Where(x => x.Item2).Select(x => x.Item1);
    }
}
