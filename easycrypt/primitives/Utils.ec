(* Utils.ec - Complete version matching paper *)
require import AllCore IntDiv Ring StdOrder.
require import Real RealExp LogExp.
require import ZArith.
require import Common.

(* Basic lattice operations from paper *)
op dot_product (n: int) (v1 v2: zq_vector(n)): real = {
  var result: real = 0%r;
  for i = 0 to n - 1 do {
    result <- result + to_real(v1[i]) * to_real(v2[i]);
  }
  return result;
}.
op vector_norm (n: int) (v: zq_vector(n)): real = {
  sqrt (dot_product n v v)
}.
op matrix_vector_mult_mod (m n: int) (A: zq_matrix(m, n)) (v: zq_vector(n)): zq_vector(m) = {
  var result: zq_vector(m);
  for i = 0 to m - 1 do {
    var sum: int = 0;
    for j = 0 to n - 1 do {
      sum <- (sum +% (A[i][j] *% v[j])) % q;
    }
    result[i] <- sum;
  }
  return result;
}.

(* Helper function: Ceiling of a real number *)
op ceil(x: real): int = {
  var r: int = floor(x);
  if real_of_int(r) < x then
    return r + 1;
  else
    return r;
}.