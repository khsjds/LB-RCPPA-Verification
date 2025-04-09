(* SISProblem.ec - Complete version matching paper *)
require import AllCore IntDiv Ring StdOrder.
require import Real RealExp LogExp.
require import ZArith.
require import Common Utils.

(* SIS Problem as defined in paper *)
module type SIS_Problem = {
  (* Generate random matrix A ∈ Zₙˣᵐ_q *)
  proc gen(p:params): zq_matrix(p.n, p.m)
  
  (* Find solution s ≠ 0 where As = 0 mod q and ||s|| ≤ β *)
  proc solve(A:zq_matrix(p.n, p.m), p: params): zq_vector(p.m)
}.

(* SIS solution verification from paper's definition *)
op is_SIS_solution (p: params) (A:zq_matrix(p.n, p.m)) (s:zq_vector(p.m)): bool =
  s <> zero_vector(p.m) /\
  matrix_vector_mult_mod p.n p.m A s = zero_vector(p.n) /\
  vector_norm p.m s <= p.beta.

(* Security definitions from paper *)
module SIS_Game (Adversary: SIS_Problem) = {
  proc main(): bool = {
    var p: params;
    var A: zq_matrix(p.n, p.m);
    var s: zq_vector(p.m);
    
    (* Get parameters satisfying paper constraints *)
    p <- get_params();
    
    (* Generate SIS instance *)
    A <- Adversary.gen(p);
    
    (* Get solution *)
    s <- Adversary.solve(A, p);
    
    (* Verify according to paper definition *)
    return is_SIS_solution p A s;
  }
}.

proc get_params(): params = {
  var p: params;
  var n, m, q: int;
  var beta, c, omega_value, sqrt_n_log_n, log_n, log_q: real;

  n <- 256;
  q <- 65537; // 2^16+1
  log_q <- log(real_of_int(q)); // ln of q
  m <- ceil(5.0 * real_of_int(n) * log_q);
  c <- 2.0 // const > 1
  log_n <- log(real_of_int(n));
  sqrt_n_log_n <- sqrt(real_of_int(n) * log_n);
  omega_value <- c*sqrt_n_log_n;
  beta <- real_of_int(q) / omega_value;

  p.n <- n;
  p.m <- m;
  p.q <- q;
  p.beta <- beta;

  if check_params(p) then
    return p;
  else
    failwith "Generated parameters do not satisfy conditions";
}

(* Advantage definition as per paper *)
op SIS_advantage (Adversary: SIS_Problem): real =
  Pr[SIS_Game(Adversary).main()].

(* Hardness assumption from paper *)
axiom SIS_hardness:
  forall (Adversary: SIS_Problem) (lambda:int),
    SIS_advantage Adversary <= negligible(lambda).

(* Connection to paper's lemmas *)
lemma sis_reduction_sound:
  forall (Adversary: SIS_Problem) (p:params),
    SIS_advantage Adversary > negligible(lambda) =>
    exists (s:zq_vector(p.m)),
      is_SIS_solution p (Adverary.gen(p)) s.