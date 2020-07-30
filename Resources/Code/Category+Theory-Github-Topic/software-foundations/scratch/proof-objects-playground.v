Require Export IndProp.

Print ev.

(* ===>
Inductive ev : nat -> Prop :=
    ev_0 : ev 0 | ev_SS : forall n : nat, ev n -> ev (S (S n))

For ev: Argument scope is [nat_scope]
For ev_SS: Argument scopes are [nat_scope _]
*)

(* This pun, ":" "has type of", or "is a proof of", is the Curry-Howard correspondance.

propositions  ~  types
proofs        ~  data values
*)

Check ev_SS.
(* ===>
ev_SS
     : forall n : nat, ev n -> ev (S (S n))
*)

Theorem ev_4 : ev 4.
Proof.
  apply ev_SS. apply ev_SS. apply ev_0.
Qed.

Print ev_4.
(* ===>
ev_4 = ev_SS 2 (ev_SS 0 ev_0)
    : ev 4
*)

(* Writing the proof object directly *)
Check (ev_SS 2 (ev_SS 0 ev_0)).
(* ===>
ev 4
*)

Theorem ev_4': ev 4.
Proof.
    apply (ev_SS 2 (ev_SS 0 ev_0)).
Qed.

(* In proofs and propositions lemmas and hypotheses can be combined in expressions, that is, proof objectsi, according to the same basic rules used for programs in the language. *)

(* We can use the "Show Proof." command to show the current proof state is it is constructed. It is possible to write proofs in this way as opposed to using tactics. The same evidence is always printed for theorems and definitions. *)
Theorem ev_4'' : ev 4.
Proof.
  Show Proof.
  (* ?Goal *)
  apply ev_SS.
  Show Proof.
  (* ev_SS 2 ?Goal *)
  apply ev_SS.
  Show Proof.
  (* ev_SS 2 (ev_SS 0 ?Goal) *)
  apply ev_0.
  Show Proof.
  (* ev_SS 2 (ev_SS 0 ev_0) *)
Qed.

Definition ev_4''' : ev 4 :=
  ev_SS 2 (ev_SS 0 ev_0).

Print ev_4.
(* ===> ev_4    = ev_SS 2 (ev_SS 0 ev_0) : ev 4 *)
Print ev_4'.
(* ===> ev_4'   = ev_SS 2 (ev_SS 0 ev_0) : ev 4 *)
Print ev_4''.
(* ===> ev_4''  = ev_SS 2 (ev_SS 0 ev_0) : ev 4 *)
Print ev_4'''.
(* ===> ev_4''' = ev_SS 2 (ev_SS 0 ev_0) : ev 4 *)

(* Exercise: Give a tactic proof and a proof object showing that ev 8. *)

Theorem ev_8 : ev 8.
Proof.
  apply ev_SS.
  apply ev_SS.
  apply ev_SS.
  apply ev_SS.
  apply ev_0.
  Show Proof.
Qed.

Definition ev_8' : ev 8 :=
  (ev_SS 6 (ev_SS 4 (ev_SS 2 (ev_SS 0 ev_0)))).

(* In Coq's computational universe there are two sorts of values with arrows in their types: constructors introduced by inductively defined data types, and functions. Similarly in Coq's logical universe, where we carry out proofs, there are two ways of giving evidence for an implication: constructors introduced by inductively defined propositions, and functions. *)

Theorem ev_plus4 : forall n, ev n -> ev (4 + n).
Proof.
  intros n H. simpl.
  apply ev_SS.
  apply ev_SS.
  apply H.
Qed.

Definition ev_plus4' : forall n, ev n -> ev (4 + n) :=
  fun (n : nat) => fun (H : ev n) =>
    ev_SS (S (S n)) (ev_SS n H).

Check ev_plus4'.
(* ===>
ev_plus4'
    : forall n : nat, ev n -> ev (4 + n)
*)

Definition ev_plus4'' (n : nat) (H : ev n) : ev (4 + n) :=
  ev_SS (S (S n)) (ev_SS n H).

Check ev_plus4''.
(* ===> ev_plus4'' : forall n : nat, ev n -> ev (4 + n) *)

Definition ev_plus2' : Prop :=
  forall n, forall (_ : ev n), ev (n + 2).

(* Equivalently, we can write it in more familiar notation: *)
Definition ev_plus2'' : Prop :=
  forall n, ev n -> ev (n + 2).

(* In general, "P → Q" is just syntactic sugar for "∀ (_:P), Q". *)
