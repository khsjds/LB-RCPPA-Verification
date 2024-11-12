(* SISProblem.ec *)
require import AllCore IntDiv Ring StdOrder.
require import Real RealExp LogExp.
require import Utils.  (* For matrix operations *)
require import Common. (* For parameters *)

(* SIS Problem specific types *)
type matrix = int array array. (* q-ary matrices *)
type vector = int array.       (* q-ary vectors *)

(* SIS instance *)
module type SIS_Instance = {
  proc gen(params: common_params): matrix (* Generate A *)
  proc solve(A: matrix): vector           (* Find solution s *)
}.

(* SIS Problem Definition *)
module SIS (SI: SIS_Instance) = {
  proc main(): bool = {
    var A, s;
    var valid: bool;
    
    (* Get system parameters *)
    var params;
    params <- get_params();  (* from Common.ec *)
    
    (* Generate SIS instance *)
    A <@ SI.gen(params);
    
    (* Get solution *)
    s <@ SI.solve(A);
    
    (* Verify solution *)
    valid <- false;
    if (s <> zero_vector) {
      if (matrix_mult A s = zero_vector) { (* from Utils.ec *)
        if (vector_norm s <= beta) {       (* from Common.ec *)
          valid <- true;
        }
      }
    }
    
    return valid;
  }
}.

(* SIS Advantage Definition *)
module SIS_Adv (A: Adversary) = {
  proc main(): bool = {
    var win;
    
    win <@ SIS(A).main();
    return win;
  }
}.