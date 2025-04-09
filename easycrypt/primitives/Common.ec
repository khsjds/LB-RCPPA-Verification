(* Common.ec *)
require import AllCore IntDiv Ring StdOrder.
require import Real RealExp LogExp.
require import ZArith.

(* Define the modulus q as a global constant *)
const q: int.

(* Types for SIS with enforced dimensions and modulus *)
type zq_vector(n: int) = { v: int[n] | forall i, 0 <= i < q }.
type zq_matrix(m n: int) = { A: int[m][n] | forall i j, 0 <= A[i][j] < q }.

(* Parameters *)
type params = {
  n : int;     (* Lattice dimension *)
  m : int;     (* Matrix dimension *)
  q : int;     (* Modulus *)
  beta: real;  (* Norm bound *)
}.

(* Essential parameter conditions as a function *)
op check_params (p: params): bool = 
  (0 < p.n) /\ (0 < p.m) /\ (0 < p.q) /\
  prime p.q /\
  p.m >= 5 * p.n * log p.q%r /\
  p.q >= p.beta * omega(sqrt(p.n * log p.n)).

(* Basic modular arithmetic operations *)
op (+%) (x y: int): int = (x + y) mod q.
op (-%) (x y: int): int = (x - y) mod q.
op (*%) (x y: int): int = (x * y) mod q.

(* Zero vector and zero matrix *)
op zero_vector(n: int): zq_vector(n) = 
  [@int | i < n => 0].

op zero_matrix(m n: int): zq_matrix(m, n) = 
  [@zq_vector(n) | i < m => zero_vector(n)].

(* Lemmas for modular arithmetic properties *)

lemma mod_add_correct:
  forall x y: int,
    (x +% y) = ((x mod q) + (y mod q)) mod q.
proof.
  unfold (+%).
  rewrite Z.add_mod_idemp_l by auto.
  trivial.
qed.

lemma mod_sub_correct:
  forall x y: int,
    (x -% y) = ((x mod q) - (y mod q)) mod q.
proof.
  unfold (-%).
  rewrite Zminus_mod_idemp_l by auto.
  trivial.
qed.

lemma mod_mul_correct:
  forall x y: int,
    (x *% y) = ((x mod q) * (y mod q)) mod q.
proof.
  unfold (*%).
  rewrite Z.mul_mod_idemp_l by auto.
  trivial.
qed.

(* Enforcing dimensions via types eliminates the need for matrix dimension axioms *)

(* Additional utility functions and definitions can be added as needed *)