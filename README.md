# LB-RCPPA Formal Verification — Tamarin Models

This directory contains the Tamarin Prover models for formally verifying the security properties of the **Lattice-Based Ring Signature-Based Conditional Privacy Preserving Authentication (LB-RCPPA)** protocol.

LB-RCPPA is a post-quantum authentication and privacy-preserving framework for Vehicular Ad Hoc Networks (VANETs). The formal models verify 16 security and privacy properties under the full Dolev-Yao adversary model.

The models use Tamarin Prover v1.10.0 with `--auto-sources` precomputation.

---

## File Layout

```
Tamarin/
├── lbrcppa_v6.spthy        # Development model (final, post-reviewer-fixes)
├── lbrcppa.spthy           # [REMOVED — public version lives in GitHub repo]
├── README.md               # This file
├── verification_status.md  # Full version history and step counts
└── Archived/               # Earlier versions (v1–v5, dev)
```

The public release model is at `../../../Downloads/LB-RCPPA-Verification-main/lbrcppa.spthy` (GitHub: LB-RCPPA-Verification). It is the cleaned version of `lbrcppa_v6.spthy` with internal tracking comments stripped.

---

## Protocol Phases Modelled

1. **System Setup** — system parameters, RSU key deployment, vehicle TPD initialization
2. **Vehicle Shares Production** — credential shares via interactive key exchange (Bi-GISIS)
3. **Signature Generation** — lattice-based ring signature construction
4. **Message Verification** — signature verification by RSUs/vehicles
5. **Reauthentication** — lightweight session reauthentication
6. **Member List Update** — credential update and pseudonym regeneration

All six phases are reachable in the final model (Phase 6 required the `unique_update` fix in v6).

---

## Verified Security Properties — 16/16

All 16 lemmas verified in `lbrcppa_v6.spthy` (2026-04-28, final). Step counts are from the post-reviewer-fixes run.

| # | Lemma | Category | Type | Steps |
|---|-------|----------|------|-------|
| 1 | `sess_valid_send` | Session validity | all-traces | 2 |
| 2 | `sess_valid_recv` | Session validity | all-traces | 2 |
| 3 | `ts_valid` | Replay protection | all-traces | 2 |
| 4 | `sess_indep` | Session independence | all-traces | 2 |
| 5 | `session_isolation` | Session isolation | all-traces | 2 |
| 6 | `x_sess_unlink` | Cross-session unlinkability | all-traces | 2 |
| 7 | `ppid_unlink` | Pseudonym unlinkability | all-traces | 2 |
| 8 | `session_key_secrecy` | Session key secrecy | `[reuse, heuristic=I]` | 12 |
| 9 | `regattempt_implies_init` | Registration integrity *(helper)* | `[sources]` | 57 |
| 10 | `record_implies_init` | ML record integrity *(helper)* | `[reuse, use_induction]` | 16,748 |
| 11 | `expireml_implies_witness` | ML expiry integrity *(helper)* | `[reuse]` | 6 |
| 12 | `recordml_transition` | ML state transition *(helper)* | `[reuse, use_induction, heuristic=I]` | 82,350 |
| 13 | `vid_privacy` | Vehicle identity privacy | `[reuse]` | 6 |
| 14 | `ml_acl_implies_reveal` | Authorized disclosure | `[reuse]` | 4 |
| 15 | `ml_consistency` | Member list consistency | all-traces | 15 |
| 16 | `auth_resolve` | Authorized identity traceability | `[reuse]` | 8 |

Lemmas 1–7 are "trivial" (2 steps each) — tight session-level properties with no reuse dependencies.
Lemmas 9–12 are inductive helpers; they must be proved explicitly even though they serve as `[reuse]` axioms for subsequent lemmas.

---

## Execution

**Never run two Tamarin instances in parallel** — peak RSS reaches ~32 GB; parallel runs will OOM-kill.

All commands use `lbrcppa_v6.spthy` (dev). For the public GitHub version substitute `lbrcppa.spthy`; the models are identical in content.

### Recommended proof order

```bash
# Step 1 — 7 trivials (fast, batch together)
tamarin-prover lbrcppa_v6.spthy \
  --prove=sess_valid_send --prove=sess_valid_recv --prove=ts_valid \
  --prove=sess_indep --prove=session_isolation \
  --prove=x_sess_unlink --prove=ppid_unlink \
  --auto-sources --derivcheck-timeout=0 +RTS -M32G -N4 -RTS

# Step 2 — session key secrecy ([heuristic=I] annotation in lemma handles heuristic)
tamarin-prover lbrcppa_v6.spthy --prove=session_key_secrecy \
  --auto-sources --derivcheck-timeout=0 +RTS -M32G -N4 -RTS

# Step 3 — registration / ML integrity helpers
tamarin-prover lbrcppa_v6.spthy --prove=regattempt_implies_init \
  --auto-sources --derivcheck-timeout=0 +RTS -M32G -N4 -RTS
tamarin-prover lbrcppa_v6.spthy --prove=record_implies_init \
  --auto-sources --derivcheck-timeout=0 +RTS -M32G -N4 -RTS

# Step 4 — expiry + ML transition (combine; expireml_implies_witness [reuse] is dependency for recordml_transition)
tamarin-prover lbrcppa_v6.spthy \
  --prove=expireml_implies_witness --prove=recordml_transition \
  --auto-sources --derivcheck-timeout=0 +RTS -M32G -N4 -RTS

# Step 5 — privacy and traceability [reuse] lemmas
tamarin-prover lbrcppa_v6.spthy \
  --prove=vid_privacy --prove=ml_acl_implies_reveal \
  --auto-sources --derivcheck-timeout=0 +RTS -M32G -N4 -RTS
tamarin-prover lbrcppa_v6.spthy \
  --prove=ml_consistency --prove=auth_resolve \
  --auto-sources --derivcheck-timeout=0 +RTS -M32G -N4 -RTS
```

### Modelling notes

- **Ring member sourcing**: Ring members 2–3 in `Generate_Message` are sourced from `In()` (DY-observable public keys) rather than `!V_Sig_Keys`. Using `!V_Sig_Keys` creates 3^3=27 source fan-out cases (OOM); `In()` reduces this to 3 tractable cases.
- **Session key abstraction**: The Bi-GISIS key exchange result is modelled as a single term `skey(r_V, r_RSU, nonce_V, nonce_RSU)` — a standard symbolic abstraction for a NIKE/DHKE-style construction.
- **`[heuristic=I]`**: Applied to `session_key_secrecy` and `recordml_transition` via in-lemma annotation. The default `s` heuristic chases adversary-injected `In()` terms for 100+ min without convergence; `I` (oldest-goal-first) converges in 12 and 82,350 steps respectively.
- **`unique_update` restriction**: Enforces at most one `UpdateInit` per `ppid` globally, making Phase 6 reachable (Phase 6 was unreachable in v5 due to `#i < #j` which was vacuously true).

---

## Version History

| Version | Date | Key change |
|---------|------|-----------|
| v1–v4 | 2025 | Integer-lattice (SIS/ISIS) base model |
| v5 | 2026-04 | Module-lattice migration (MSIS/MLWE); 16 lemmas; Phase 6 unreachable |
| v6 | 2026-04-27 | `unique_update` fix (Phase 6 live); ring members 2-3 via `In()`; `[heuristic=I]` on sks |
| v6 post-fix | 2026-04-28 | Reviewer fixes applied; `verify_after_session` vacuous restriction removed; all 16 lemmas re-verified |

Full step counts and proof commands for each version: see `verification_status.md`.

---

## Contact

**Tao-hsiang Chang** — tchang@cs.nccu.edu.tw
