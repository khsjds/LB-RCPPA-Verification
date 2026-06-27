# LB-RCPPA Formal Verification — Tamarin Models

This repository contains the Tamarin Prover models for formally verifying the security properties of the **Lattice-Based Ring Signature-Based Conditional Privacy Preserving Authentication (LB-RCPPA)** protocol.

LB-RCPPA is a post-quantum authentication and privacy-preserving framework for Vehicular Ad Hoc Networks (VANETs). The formal models verify 16 security and privacy properties under the full Dolev-Yao adversary model.

The models use Tamarin Prover v1.10.0 with `--auto-sources` precomputation.

---

## Repository Structure

```
LB-RCPPA-Verification/
├── Archived/              # Earlier development versions and experimental models
├── lbrcppa.spthy          # Finalized Tamarin model (v6, post-reviewer-fixes, 2026-04-28)
└── README.md              # This file
```

---

## Protocol Phases Modelled

1. **System Setup** — system parameters, RSU key deployment, vehicle TPD initialization
2. **Vehicle Shares Production** — credential shares via interactive key exchange (Bi-GISIS)
3. **Signature Generation** — lattice-based ring signature construction
4. **Message Verification** — signature verification by RSUs/vehicles
5. **Reauthentication** — lightweight session reauthentication
6. **Member List Update** — credential update and pseudonym regeneration

All six phases are reachable in the final model.

---

## Verified Security Properties — 16/16

All 16 lemmas verified in `lbrcppa.spthy` (2026-04-28, final).

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
Lemmas 9–12 are inductive helpers that must be proved explicitly before the `[reuse]` lemmas that depend on them.

---

## Execution

> **Important:** Do not run multiple Tamarin instances in parallel — peak RAM usage reaches ~32 GB. Run proofs sequentially.

### Requirements

- Tamarin Prover v1.10.0
- `+RTS -M32G -N4 -RTS` (adjust `-N` to your core count; `-M32G` is the minimum recommended)

### Recommended proof order

```bash
# Step 1 — 7 trivial lemmas (fast, batch together)
tamarin-prover lbrcppa.spthy \
  --prove=sess_valid_send --prove=sess_valid_recv --prove=ts_valid \
  --prove=sess_indep --prove=session_isolation \
  --prove=x_sess_unlink --prove=ppid_unlink \
  --auto-sources --derivcheck-timeout=0 +RTS -M32G -N4 -RTS

# Step 2 — session key secrecy
tamarin-prover lbrcppa.spthy --prove=session_key_secrecy \
  --auto-sources --derivcheck-timeout=0 +RTS -M32G -N4 -RTS

# Step 3 — registration and ML integrity helpers
tamarin-prover lbrcppa.spthy --prove=regattempt_implies_init \
  --auto-sources --derivcheck-timeout=0 +RTS -M32G -N4 -RTS
tamarin-prover lbrcppa.spthy --prove=record_implies_init \
  --auto-sources --derivcheck-timeout=0 +RTS -M32G -N4 -RTS

# Step 4 — ML expiry and transition helpers
tamarin-prover lbrcppa.spthy \
  --prove=expireml_implies_witness --prove=recordml_transition \
  --auto-sources --derivcheck-timeout=0 +RTS -M32G -N4 -RTS

# Step 5 — privacy and traceability lemmas
tamarin-prover lbrcppa.spthy \
  --prove=vid_privacy --prove=ml_acl_implies_reveal \
  --auto-sources --derivcheck-timeout=0 +RTS -M32G -N4 -RTS
tamarin-prover lbrcppa.spthy \
  --prove=ml_consistency --prove=auth_resolve \
  --auto-sources --derivcheck-timeout=0 +RTS -M32G -N4 -RTS
```

---

## Modelling Notes

- **Ring member sourcing**: Ring members 2–3 in `Generate_Message` are sourced from `In()` (DY-observable public keys) rather than `!V_Sig_Keys`. Using `!V_Sig_Keys` creates 3³=27 source fan-out cases (OOM); `In()` reduces this to 3 tractable cases.
- **Session key abstraction**: The Bi-GISIS key exchange result is modelled as a single term `skey(r_V, r_RSU, nonce_V, nonce_RSU)` — standard symbolic abstraction for a NIKE/DHKE-style construction.
- **`[heuristic=I]`**: Applied to `session_key_secrecy` and `recordml_transition`. The default `s` heuristic does not converge for these lemmas; `I` (oldest-goal-first) converges in 12 and 82,350 steps respectively.
- **`unique_update` restriction**: Enforces at most one `UpdateInit` per `ppid` globally, making Phase 6 (Member List Update) reachable.

---

## Version History

| Version | Date | Key change |
|---------|------|-----------|
| v1–v4 | 2025 | Integer-lattice (SIS/ISIS) base model |
| v5 | 2026-04 | Module-lattice migration (MSIS/MLWE); 16 lemmas; Phase 6 unreachable |
| v6 | 2026-04-27 | `unique_update` fix (Phase 6 live); ring members 2–3 via `In()`; `[heuristic=I]` on sks |
| v6 post-fix | 2026-04-28 | Reviewer fixes applied; all 16 lemmas re-verified |

Earlier development models are in the `Archived/` directory.

---

## Contact

**Tao-hsiang Chang** — tchang@cs.nccu.edu.tw
