﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using static KitchenSink.Operators;

namespace KitchenSink.Extensions
{
    public static class EnumerableExtensions
    {
        /// <summary>
        /// Returns true if item is in sequence.
        /// </summary>
        public static bool IsIn<A>(this A val, params A[] vals) => IsIn(val, (IEnumerable<A>) vals);

        /// <summary>
        /// Returns true if item is in sequence.
        /// </summary>
        public static bool IsIn<A>(this A val, IEnumerable<A> seq) => seq.Any(Apply<A, A, bool>(Eq, val));

        /// <summary>
        /// Returns true if item is not in sequence.
        /// </summary>
        public static bool IsNotIn<A>(this A val, params A[] vals) => !IsIn(val, (IEnumerable<A>) vals);

        /// <summary>
        /// Returns true if item is not in sequence.
        /// </summary>
        public static bool IsNotIn<A>(this A val, IEnumerable<A> seq) => !IsIn(val, seq);

        /// <summary>
        /// If sequence is empty, replace with sequence of given value(s).
        /// </summary>
        public static IEnumerable<A> IfEmpty<A>(this IEnumerable<A> xs, params A[] values) => IfEmpty(xs, (IEnumerable<A>)values);

        /// <summary>
        /// If sequence is empty, replace with given sequence.
        /// </summary>
        public static IEnumerable<A> IfEmpty<A>(this IEnumerable<A> xs, IEnumerable<A> ys)
        {
            var any = false;

            foreach (var x in xs)
            {
                any = true;
                yield return x;
            }

            if (!any)
            {
                foreach (var y in ys)
                {
                    yield return y;
                }
            }
        }

        /// <summary>
        /// Returns greatest item in sequence according to comparer, preferring earlier elements.
        /// </summary>
        public static A MaxBy<A>(this IEnumerable<A> xs, IComparer<A> comparer) =>
            xs.Aggregate(comparer.Max);

        /// <summary>
        /// Returns least item in sequence according to comparer, preferring earlier elements.
        /// </summary>
        public static A MinBy<A>(this IEnumerable<A> xs, IComparer<A> comparer) =>
            xs.Aggregate(comparer.Min);

        /// <summary>
        /// Returns greatest item in sequence according to comparer, preferring earlier elements.
        /// </summary>
        public static Maybe<A> MaxByMaybe<A>(this IEnumerable<A> xs, IComparer<A> comparer) =>
            xs.Aggregate(None<A>(), (m, x2) => m.Select(x1 => comparer.Max(x1, x2)).Or(Some(x2)));

        /// <summary>
        /// Returns least item in sequence according to comparer, preferring earlier elements.
        /// </summary>
        public static Maybe<A> MinByMaybe<A>(this IEnumerable<A> xs, IComparer<A> comparer) =>
            xs.Aggregate(None<A>(), (m, x2) => m.Select(x1 => comparer.Min(x1, x2)).Or(Some(x2)));

        /// <summary>
        /// Adapter for specialized collections that do not implement <see cref="IEnumerable{A}"/>.
        /// Eagerly reads enumerator results into list.
        /// Result can be enumerated multiple times.
        /// </summary>
        public static IEnumerable AsEnumerable(this IEnumerator e)
        {
            while (e.MoveNext())
            {
                yield return e.Current;
            }
        }

        /// <summary>
        /// Adapter for specialized collections that do not implement <see cref="IEnumerable{A}"/>.
        /// </summary>
        public static IEnumerable<A> AsEnumerable<A>(this IEnumerator<A> e)
        {
            while (e.MoveNext())
            {
                yield return e.Current;
            }
        }

        /// <summary>
        /// Adapter for specialized collections that do not implement <see cref="IEnumerable{A}"/>.
        /// Lazily reads enumerator results and returns them.
        /// Result can be enumerated only once.
        /// </summary>
        public static IEnumerable<A> AsEnumerableNonRepeatable<A>(this IEnumerator e)
        {
            while (e.MoveNext())
            {
                yield return (A) e.Current;
            }
        }

        /// <summary>
        /// Sorts elements by their natural order.
        /// </summary>
        public static IEnumerable<A> Sort<A>(this IEnumerable<A> seq) where A : IComparable =>
            seq.OrderBy(x => x);

        /// <summary>
        /// Sorts elements descending by their natural order.
        /// </summary>
        public static IEnumerable<A> SortDescending<A>(this IEnumerable<A> seq) where A : IComparable =>
            seq.OrderByDescending(x => x);

        /// <summary>
        /// Sorts elements according to given comparer.
        /// </summary>
        public static IEnumerable<A> Sort<A>(this IEnumerable<A> seq, IComparer<A> comparer) =>
            seq.OrderBy(x => x, comparer);

        /// <summary>
        /// Sorts elements descending according to given comparer.
        /// </summary>
        public static IEnumerable<A> SortDescending<A>(this IEnumerable<A> seq, IComparer<A> comparer) =>
            seq.OrderByDescending(x => x, comparer);

        /// <summary>
        /// Sorts elements according to given comparer.
        /// </summary>
        public static IEnumerable<A> Sort<A>(this IEnumerable<A> seq, Func<A, A, Comparison> f) =>
            seq.OrderBy(x => x, new ComparisonComparer<A>(f));

        /// <summary>
        /// Sorts elements descending according to given comparer.
        /// </summary>
        public static IEnumerable<A> SortDescending<A>(this IEnumerable<A> seq, Func<A, A, Comparison> f) =>
            seq.OrderByDescending(x => x, new ComparisonComparer<A>(f));

        private class ComparisonComparer<A> : IComparer<A>
        {
            private readonly Func<A, A, Comparison> f;

            public ComparisonComparer(Func<A, A, Comparison> f) => this.f = f;

            public int Compare(A x, A y) =>
                f(x, y) switch
                {
                    Comparison.Gt => 1,
                    Comparison.Lt => -1,
                    Comparison.Eq => 0,
                    _ => throw new ArgumentOutOfRangeException()
                };
        }

        /// <summary>
        /// Returns elements in given sequence as sub-sequences of given size.
        /// Example: <c>[1, 2, 3, 4, 5, 6, 7, 8], 3 => [[1, 2, 3], [4, 5, 6], [7, 8]]</c>
        /// </summary>
        public static IEnumerable<IEnumerable<A>> Batch<A>(this IEnumerable<A> seq, int count)
        {
            var segment = new A[count];
            var i = 0;

            foreach (var item in seq)
            {
                segment[i] = item;
                i++;

                if (i == count)
                {
                    yield return segment;
                    segment = new A[count];
                    i = 0;
                }
            }

            if (i > 0)
            {
                yield return segment.Take(i);
            }
        }

        /// <summary>
        /// Returns sequence that eagerly reads from given sequence in groups of <c>count</c>.
        /// </summary>
        public static IEnumerable<A> Buffer<A>(this IEnumerable<A> seq, int count) =>
            seq.Batch(count).Select(x => x.ToArray()).Flatten();

        /// <summary>
        /// Combines a sequence of sub-sequences into one long sequence.
        /// Example: <c>[[1, 2, 3], [4, 5], [6, 7, 8]] => [1, 2, 3, 4, 5, 6, 7, 8]</c>
        /// </summary>
        public static IEnumerable<A> Flatten<A>(this IEnumerable<IEnumerable<A>> seq) =>
            seq.SelectMany(Id);

        /// <summary>
        /// Combines sub-sequences of arbitrary and varied depth, as determined
        /// by given <c>Either</c> function.
        /// Example: <c>[[1, [2, 3]], [[4], 5], [[6, 7], 8]] => [1, 2, 3, 4, 5, 6, 7, 8]</c>
        /// </summary>
        public static IEnumerable<B> Flatten<A, B>(this IEnumerable<A> seq, Func<A, Either<B, IEnumerable<A>>> f) =>
            seq.SelectMany(x => f(x).Branch(y => SeqOf(y), ys => Flatten(ys, f)));

        /// <summary>
        /// Returns sequence of overlapping pairs of elements in given sequence.
        /// Example: <c>[1, 2, 3, 4, 5] => [[1, 2], [2, 3], [3, 4], [4, 5]]</c>
        /// </summary>
        public static IEnumerable<(A, A)> OverlappingPairs<A>(this IEnumerable<A> seq)
        {
            using var e = seq.GetEnumerator();

            if (!e.MoveNext()) yield break;

            var previous = e.Current;

            if (!e.MoveNext()) throw new ArgumentException("too few elements");

            var current = e.Current;
            yield return (previous, current);

            while (e.MoveNext())
            {
                previous = current;
                current = e.Current;
                yield return (previous, current);
            }

            e.Dispose();
        }

        /// <summary>
        /// Returns a sequence with a copy of <c>separator(s)</c> between each
        /// element of the original sequence.
        /// Example: <c>[1, 2, 3], [4, 5, 6] => [1, 4, 5, 6, 2, 4, 5, 6, 3]</c>
        /// </summary>
        public static IEnumerable<A> Intersperse<A>(this IEnumerable<A> seq, params A[] separators) =>
            Intersperse(seq, (IEnumerable<A>)separators);

        /// <summary>
        /// Returns a sequence with copies of <c>separator(s)</c> between each
        /// element of the original sequence.
        /// Example: <c>[1, 2, 3], [4, 5, 6] => [1, 4, 5, 6, 2, 4, 5, 6, 3]</c>
        /// </summary>
        public static IEnumerable<A> Intersperse<A>(this IEnumerable<A> seq, IEnumerable<A> seperators)
        {
            var lazy = new Lazy<A[]>(seperators.ToArray);
            using var e = seq.GetEnumerator();

            if (!e.MoveNext()) yield break;

            yield return e.Current;

            while (e.MoveNext())
            {
                foreach (var sep in lazy.Value)
                {
                    yield return sep;
                }

                yield return e.Current;
            }

            e.Dispose();
        }

        /// <summary>
        /// Returns a sequence with a copy of <c>separator</c> between each
        /// element of the original sequence.
        /// Example: <c>[1, 2, 3], [7, 8, 9] => [1, 7, 2, 8, 3, 9]</c>
        /// </summary>
        public static IEnumerable<A> Interleave<A>(this IEnumerable<A> seq1, IEnumerable<A> seq2)
        {
            using var e1 = seq1.GetEnumerator();
            using var e2 = seq2.GetEnumerator();

            while (true)
            {
                if (!e1.MoveNext())
                {
                    while (e2.MoveNext())
                    {
                        yield return e2.Current;
                    }

                    e1.Dispose();
                    e2.Dispose();
                    yield break;
                }

                yield return e1.Current;

                if (!e2.MoveNext())
                {
                    while (e1.MoveNext())
                    {
                        yield return e1.Current;
                    }

                    e1.Dispose();
                    e2.Dispose();
                    yield break;
                }

                yield return e2.Current;
            }
        }

        /// <summary>
        /// Infinitely enumerates sequence.
        /// Example: <c>[1, 2, 3] => [1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, ...]</c>
        /// </summary>
        public static IEnumerable<A> Cycle<A>(this IEnumerable<A> seq)
        {
            var list = new List<A>();

            foreach (var item in seq)
            {
                list.Add(item);
                yield return item;
            }

            while (true)
            {
                foreach (var item in list)
                {
                    yield return item;
                }
            }

            // ReSharper disable once IteratorNeverReturns
        }

        /// <summary>
        /// Creates a <see cref="HashSet{A}"/> from an <see cref="IEnumerable{A}"/>.
        /// </summary>
        public static HashSet<A> ToSet<A>(this IEnumerable<A> seq) => new HashSet<A>(seq);

        /// <summary>
        /// Creates a <see cref="Func{B}"/> of <see cref="Maybe{A}"/> from an <see cref="IEnumerable{A}"/>.
        /// </summary>
        public static Func<Maybe<A>> AsFunc<A>(this IEnumerable<A> seq)
        {
            var e = seq.GetEnumerator();
            var done = false;
            return () =>
            {
                if (e.MoveNext()) return Some(e.Current);
                if (done) return None<A>();

                e.Dispose();
                done = true;
                return None<A>();
            };
        }

        /// <summary>
        /// Forces entire sequence to be enumerated immediately.
        /// </summary>
        public static IEnumerable<A> Force<A>(this IEnumerable<A> seq) => seq.ToArray();

        /// <summary>
        /// Optimized version of Concat for Arrays.
        /// </summary>
        public static A[] Concat<A>(this A[] array, params A[] vals)
        {
            var result = new A[array.Length + vals.Length];
            array.CopyTo(result, 0);
            vals.CopyTo(result, array.Length);
            return result;
        }

        /// <summary>
        /// Optimized version of Concat for Lists.
        /// </summary>
        public static List<A> Concat<A>(this List<A> xs, List<A> ys)
        {
            var result = new List<A>(xs.Count + ys.Count);
            result.AddRange(xs);
            result.AddRange(ys);
            return result;
        }

        /// <summary>
        /// Combines two sequences by pairing off their elements into tuples.
        /// Example: <c>[1, 2, 3], [A, B, C] => [(1, A), (2, B), (3, C)]</c>
        /// </summary>
        public static IEnumerable<(A, B)> ZipTuples<A, B>(this IEnumerable<A> xs, IEnumerable<B> ys) => xs.Zip(ys, TupleOf);

        /// <summary>
        /// Sames as the standard <see cref="Enumerable.Zip{A, B, C}"/>, but
        /// raises exception if sequences are not of the same length.
        /// </summary>
        public static IEnumerable<C> ZipExact<A, B, C>(this IEnumerable<A> xs, IEnumerable<B> ys, Func<A, B, C> f)
        {
            using var ex = xs.GetEnumerator();
            using var ey = ys.GetEnumerator();
            bool xHasNext;
            bool yHasNext;

            while ((xHasNext = ex.MoveNext()) | (yHasNext = ey.MoveNext()))
            {
                if (xHasNext != yHasNext)
                {
                    throw new InvalidOperationException("Enumerables are of different length");
                }

                yield return f(ex.Current, ey.Current);
            }

            ex.Dispose();
            ey.Dispose();
        }

        /// <summary>
        /// Sames as the standard <see cref="ZipTuples{A, B}"/>, but
        /// raises exception if sequences are not of the same length.
        /// </summary>
        public static IEnumerable<(A, B)> ZipExact<A, B>(this IEnumerable<A> xs, IEnumerable<B> ys) => xs.ZipExact(ys, TupleOf);

        /// <summary>
        /// Returns a sequence of items paired with their index in the original sequence.
        /// Example: <c>[A, B, C] => [(0, A), (1, B), (2, C)]</c>
        /// </summary>
        public static IEnumerable<(int, A)> ZipWithIndex<A>(this IEnumerable<A> seq) => From(0).ZipTuples(seq);

        /// <summary>
        /// Returns the cross product of two sequences, combining elements with the given function.
        /// Example: <c>[1, 2, 3], [4, 5], (*) => [4, 5, 8, 10, 12, 15]</c>
        /// </summary>
        public static IEnumerable<C> CrossJoin<A, B, C>(this IEnumerable<A> xs, IEnumerable<B> ys, Func<A, B, C> f) =>
            xs.SelectMany(x => ys.Select(y => f(x, y)));

        /// <summary>
        /// Returns the cross product of two sequences, combining elements into tuples.
        /// Example: <c>[A, B, C], [1, 2] => [(A, 1), (A, 2), (B, 1), (B, 2), (C, 1), (C, 2)]</c>
        /// </summary>
        public static IEnumerable<(A, B)> CrossJoin<A, B>(this IEnumerable<A> xs, IEnumerable<B> ys) =>
            xs.CrossJoin(ys, TupleOf);

        /// <summary>
        /// Returns a dictionary of element counts indexed by an arbitrary property.
        /// Example: <c>[3, -2, 8, 0, -1, 4, -5, 6], Sign => {{-1, 3}, {0, 1}, {1, 4}}</c>
        /// </summary>
        public static IDictionary<B, int> CountBy<A, B>(this IEnumerable<A> seq, Func<A, B> f) =>
            seq.GroupBy(f).ToDictionary(x => x.Key, x => x.Count());

        /// <summary>
        /// Returns sequence, excluding elements at given indicies.
        /// Example: <c>[1, 2, 3, 4, 5, 6, 7, 8], 3, 5 => [1, 2, 3, 5, 7, 8]</c>
        /// </summary>
        public static IEnumerable<A> ExceptAt<A>(this IEnumerable<A> seq, params int[] indicies) =>
            seq.Where((_, i) => i.IsNotIn(indicies));

        /// <summary>
        /// Filters out <c>null</c> values.
        /// </summary>
        public static IEnumerable<A> Sift<A>(this IEnumerable<A> seq) =>
            seq.Where(x => x != null);

        /// <summary>
        /// Filters out elements for which the given selector returns <c>null</c>.
        /// </summary>
        public static IEnumerable<A> Sift<A, B>(this IEnumerable<A> seq, Func<A, B> f) =>
            seq.Where(x => f(x) != null);

        /// <summary>
        /// Randomizes elements in sequence. This will enumerate the entire sequence.
        /// Example: <c>[1, 2, 3, 4, 5] => [3, 5, 2, 1, 4]</c>
        /// </summary>
        public static IEnumerable<A> Shuffle<A>(this IEnumerable<A> seq, Random rand = null)
        {
            rand ??= new Random();
            var values = seq.ToArray();

            for (var i = 0; i < values.Length; ++i)
            {
                var j = rand.Next(i, values.Length);
                yield return values[j];
                values[j] = values[i];
            }
        }

        /// <summary>
        /// Splits sequence into <c>n</c> sub-sequences, each containing every <c>n</c>th element.
        /// Example: <c>[1, 2, 3, 4, 5, 6], 2 => [[1, 3, 5], [2, 4, 6]]</c>
        /// </summary>
        public static IEnumerable<IEnumerable<A>> Deal<A>(this IEnumerable<A> seq, int n)
        {
            var count = 0L;
            var etor = new Lazy<IEnumerator<A>>(seq.GetEnumerator);
            var queues = Enumerable.Range(0, n).Select(_ => new Queue<A>()).ToList();

            IEnumerable<A> TakeEveryNth(int offset)
            {
                var queue = queues[offset % n];

                while (true)
                {
                    if (queue.Count > 0)
                    {
                        yield return queue.Dequeue();
                    }
                    else if (etor.Value.MoveNext())
                    {
                        if (count % n == offset)
                        {
                            count++;
                            yield return etor.Value.Current;
                        }
                        else
                        {
                            queues[(int) (count % n)].Enqueue(etor.Value.Current);
                            count++;
                        }
                    }
                    else
                    {
                        yield break;
                    }
                }
            }

            return Enumerable.Range(0, n).Select(TakeEveryNth);
        }

        /// <summary>
        /// Performs side-effecting Action on each item in sequence and then yield it.
        /// Like <see cref="ForEach{A}"/>, but lazy and yields the values of the input sequence.
        /// Example: <c>...Where(Filter).Tap(LogValue).Select(Transform).</c>
        /// </summary>
        public static IEnumerable<A> Tap<A>(this IEnumerable<A> seq, Action<A> f) =>
            seq.Select(x => { f(x); return x; });

        /// <summary>
        /// Performs side-effecting Action on each item in sequence.
        /// Like <see cref="Tap{A}"/>, but eager and returns void.
        /// </summary>
        public static void ForEach<A>(this IEnumerable<A> seq, Action<A> f) =>
            seq.Tap(f).Force();

        /// <summary>
        /// Sets every value in array to a particular value.
        /// </summary>
        public static A[] Fill<A>(this A[] array, A value)
        {
            for (var i = 0; i < array.Length; ++i)
            {
                array[i] = value;
            }

            return array;
        }

        /// <summary>
        /// Returns enumerable that can be re-enumerated even if given enumerable can't be.
        /// </summary>
        public static IReplayableEnumerable<A> Replayable<A>(this IEnumerable<A> seq) =>
            new ReplayableEnumerable<A>(seq);
    }
    
    public interface IReplayableEnumerable<out A> : IEnumerable<A> { }

    internal class ReplayableEnumerable<A> : IReplayableEnumerable<A>
    {
        private readonly Lazy<IEnumerator<A>> source;
        private readonly Atom<(bool, List<A>)> items = Atom.Of((false, ListOf<A>()));

        public ReplayableEnumerable(IEnumerable<A> source) =>
            this.source = new Lazy<IEnumerator<A>>(source.GetEnumerator);

        public IEnumerator<A> GetEnumerator() => new Etor(this);

        private class Etor : IEnumerator<A>
        {
            private readonly ReplayableEnumerable<A> seq;
            private int index;
            private Maybe<A> current = None<A>();

            public Etor(ReplayableEnumerable<A> seq) => this.seq = seq;

            public A Current => current.OrElseThrow(new InvalidOperationException());

            public bool MoveNext() => seq.items.Update(t =>
            {
                var (done, list) = t;

                if (done)
                {
                    return (false, list);
                }

                if (index < list.Count)
                {
                    current = Some(list[index++]);
                    return (true, list);
                }

                if (!seq.source.Value.MoveNext()) return (false, list);

                var val = seq.source.Value.Current;
                list.Add(val);
                index++;
                current = Some(val);
                return (true, list);
            }).Item1;

            public void Reset() => index = 0;

            public void Dispose() { }

            object IEnumerator.Current => Current;
        }

        IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
    }
}
