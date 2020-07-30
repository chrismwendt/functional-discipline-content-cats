; install http://planck-repl.org/

; run examples
; $ planck clojure_examples.cljs

; http://elbenshira.com/p/clojure-primer-js/

;; (println "Hello World 1")

;; ((fn [message] (println message)) ; Operation
;;  "Hello World 2")                 ; Arguments

;; (#(println %) "Hello World 3")

(def messenger (fn [msg] (println msg)))
;; (messenger "Hello World 4")

(defn messenger [msg] (println msg))
;; (messenger "Hello World 5")

;; (println (let [x 4
;;                y 5]
;;            (+ x y)))

(defn printArgs [firstArg secondArg & nextArgs]
  (println "First arg: " firstArg)
  (println "Second arg: " secondArg)
  (println "Next args: " nextArgs))
;; (printArgs "aaa" "bbb" "ccc" "ddd")

; (myfn "a" "b" "c") is equivalent to (apply myfn ["a" "b" "c"])
(defn addNumbers [numbers]
  (apply + numbers))
;; (println (addNumbers '(3 6 9)))


;; list examples
;; ()
;; (list 1 2 3)
;; '(1 2 3)
;; (conj '(2 3) 1) ;=> (1 2 3)

;; vector examples
;; [1 2 3]
;; (vector 1 2 3)
;; (vec '(1 2 3))
;; (nth [1 2 3] 0) ;=> 1
;; (conj [1 2] 3)  ;=> [1 2 3]

;; map examples
;; {}
;; {:a 1 :b 2}
;; (:a {:a 1 :b 2})    ;=> 1
;; ({:a 1 :b 2} :a)    ;=> 1
;; (assoc {:a 1} :b 2) ;=> {:a 1 :b 2}
;; (dissoc {:a 1} :a)  ;=> {}
;; (conj {} [:a 1])    ;=> {:a 1}

;; set examples
;; #{}
;; #{:a :b}
;; (#{:a :b} :a)         ;=> :a
;; (conj #{} :a)         ;=> #{:a}
;; (contains? #{:a} :a)  ;=> true


(defn nestedMapExample []
  (defn getNewName [] "Zbysio")
  (def wiesiek {:name "Wiesio" :son {:name "Zdzisio"}})
  (println (get wiesiek :name)) ;; assoc function updates value
  (println (get-in wiesiek [:son :name]))
  ;; assoc-in - like update-in but with value instead of update function
  (def updatedWiesio (update-in wiesiek [:son :name] getNewName))
  (println (get-in updatedWiesio [:son :name])))
;; (nestedMapExample)


(defn destucturingExample []
  (def animals ["cat" "dog" "chupacabra" "hefalump"])
  (println (let [[_ secondAnimal & restAnimals] animals] restAnimals)))
;; (destucturingExample)

(defn fnWithNamedArgs [& {first :arg1 second :arg2}]
  (println first second))
;; (fnWithNamedArgs :arg1 "Hello" :arg2 "Args!")


