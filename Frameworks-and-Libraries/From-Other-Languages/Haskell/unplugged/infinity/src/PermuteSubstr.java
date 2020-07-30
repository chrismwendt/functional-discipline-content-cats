import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.function.LongPredicate;
import java.util.stream.Collectors;
import java.util.stream.LongStream;

/*
 * Given a string W and a text T, test if any permutation of W appears in T.
 * Examples:
 *   W = "ab" T = "excbaode", ==> true, "ba" = permute("ab") in T;
 *   W = "ab"  T = "ezdboaxy", ==> false, neither "ab", nor "ba" in T.
 */

public class PermuteSubstr {

    /*
     * Solution based on Fundamental theorem of arithmetic
     * We use Sieve of Eratosthenes to generate a stream of primes, assign each
     * unique character a prime. We can calculate the number theory finger-print
     * of W by m = product(prime[w]) for each w in W.
     * Then we scan T with a window of length |W|, calculate the finger-print
     * m' with the same method, whenever m' = m, we found a result.
     */

    private static final int ASCII = 128;
    private static LongPredicate sieves = x -> true; // initialize sieve as id
    private final static long[] PRIMES = LongStream
        .iterate(2, i -> i + 1)
        .filter(i -> sieves.test(i))  // Sieve of Eratosthenes
        .peek(i -> sieves = sieves.and(v -> v % i != 0)) // update, chain the sieve
        .limit(ASCII)                 // only support ASCII
        .toArray();

    private static BigInteger product(String str) {
        return str.chars().mapToObj(c -> primeOf(c))
            .reduce(BigInteger.ONE, BigInteger::multiply);
    }

    private static BigInteger primeOf(int c) {
        return BigInteger.valueOf(PRIMES[c - ' ']);
    }

    public static boolean exists(String w, String txt) {
        if (w.isEmpty()) {
            return true;
        }
        int m = w.length(), n = txt.length();
        if (n < m) {
            return false;
        }
        BigInteger target = product(w);
        BigInteger fp = product(txt.substring(0, m));
        for (int i = m; i < n && !target.equals(fp); ++i) {
            fp = fp.divide(primeOf(txt.charAt(i - m)))
                   .multiply(primeOf(txt.charAt(i)));
        }
        return target.equals(fp);
    }

    /*
     * Solution 2, char indexed array
     */
    public static boolean matches(String w, String txt) {
        if (w.isEmpty()) {
            return true;
        }
        int m = w.length(), n = txt.length();
        if (n < m) {
            return false;
        }
        int[] map = new int[ASCII];
        w.chars().forEach(c -> map[c]++);
        Set<Integer> chars = w.chars().filter(c -> map[c] != 0)
            .boxed().collect(Collectors.toSet());
        txt.substring(0, m).chars().forEach(c -> map[c]--);
        for (int i = m; i < n && chars.stream().anyMatch(c -> map[c] != 0); ++i) {
            map[txt.charAt(i - m)]++;
            map[txt.charAt(i)]--;
        }
        return chars.stream().allMatch(c -> map[c] == 0);
    }

    /*
     * Solution 3, with a Map from char to occurrence count
     */

    public static boolean contains(String w, String txt) {
        if (w.isEmpty()) {
            return true;
        }
        int m = w.length(), n = txt.length();
        if (n < m) {
            return false;
        }
        Map<Character, Integer> target = mapOf(w);
        Map<Character, Integer> fp = mapOf(txt.substring(0, m));
        for (int i = m; i < n && !same(target, fp); ++i) {
            fp.compute(txt.charAt(i - m), (k, v) -> v - 1);
            fp.compute(txt.charAt(i), (k, v) -> v == null ? 1 : v + 1);
        }
        return same(target, fp);
    }

    private static Map<Character, Integer> mapOf(String str) {
        Map<Character, Integer> map = new HashMap<>();
        for (char c : str.toCharArray()) {
            map.compute(c, (k, v) -> v == null ? 1 : v + 1);
        }
        return map;
    }

    // The sliding window has the same width, only need check a against b
    private static <K> boolean same(Map<K, Integer> a, Map<K, Integer> b) {
        return a.keySet().stream()
            .allMatch(k -> a.getOrDefault(k, 0) == b.getOrDefault(k, 0));
    }

    private static final String TXT = "In number theory, the fundamental theorem "
        + "of arithmetic, also called the unique factorization theorem or the "
        + "unique-prime-factorization theorem, states that every integer greater "
        + "than 1[3] either is a prime number itself or can be represented as the "
        + "product of prime numbers and that, moreover, this representation is "
        + "unique, up to (except for) the order of the factors.";

    private static final String WS = "The theorem says two things for this "
        + "example: first, that 1200 can be represented as a product of primes, "
        + "and second, that no matter how this is done, there will always be "
        + "exactly four 2s, one 3, two 5s, and no other primes in the product.";

    public static void main(String[] args) {
        for (String w : WS.split("\\s+|,\\s*|\\.\\s*")) {
            boolean a = exists(w, TXT);
            boolean b = matches(w, TXT);
            boolean c = contains(w, TXT);
            if (a != b || b != c) {
                System.out.format("err: w = [%s]: %s, %s, %s\n", w, a, b, c);
            }
        }
    }
}
