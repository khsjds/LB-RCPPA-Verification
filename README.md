# LB-RCPPA Formal Verification Repository
This repository contains the Tamarin Prover models for formally verifying the security properties of the **Lattice-Based Ring Signature-Based Conditional Privacy Preserving Authentication (LB-RCPPA)** protocol.

LB-RCPPA is a lattice-based authentication and privacy-preserving framework designed for secure communications in Vehicular Ad Hoc Networks (VANETs). The formal models verify the security properties of LB-RCPPA under post-quantum assumptions.  

The Tamarin models provided here serve as the formal verification framework supporting the theoretical security proofs presented in the LB-RCPPA research, using Tamarin Prover v1.10.0.

---

# Repository Structure
```bash
LB-RCPPA-VERIFICATION/
├── Archived/              # Archived or earlier versions of Tamarin models and testing files
├── lbrcppa.spthy          # Current finalized Tamarin model for LB-RCPPA
└── README.md              # This file
```
The directory Archived/ contains development versions, experimental models, and historical copies of previous lbrcppa.spthy. The latest copy of lbrcppa.spthy always corresponds to the most updated model (currently synchronized with lbrcppa05.spthy).

---

# Model Description
The formal Tamarin models reflect the six protocol phases designed in LB-RCPPA:

1. **System Setup**  
   Generation of system parameters, RSU key deployment, and initialization of vehicle TPDs.
2. **Vehicle Shares Production**  
   Credential shares generation through interactive key exchange protocols.
3. **Signature Generation**  
   Construction of lattice-based ring signatures for secure message authentication.
4. **Message Verification**  
   Signature verification by RSUs or other vehicles upon message reception.
5. **Reauthentication**  
   Lightweight session reauthentication for continuous communication.
6. **Member List Update**  
   Secure credential update and pseudonym regeneration procedures.

The Tamarin models specify the protocol logic, message flows, and adversary interactions across these six phases.

All 12 lemmas in `lbrcppa.spthy` are verified. The table below maps each lemma to the security property it establishes.

| Lemma | Property | Steps |
|-------|----------|-------|
| `ts_valid` | Timestamp validity — a verified timestamp was freshly created and has not yet expired (replay protection) | 2 |
| `sess_valid_send` | Session validity on send — a message can only be created under an active, non-expired session | 2 |
| `sess_valid_recv` | Session validity on receive — a message can only be received under an active, non-expired session | 2 |
| `sess_indep` | Session independence — two distinct pseudonyms cannot share a session key with the same RSU | 2 |
| `session_isolation` | Session isolation — compromising one vehicle's session key does not reveal another vehicle's session key | 2 |
| `x_sess_unlink` | Cross-session unlinkability — linking two pseudonyms to the same vehicle across sessions requires prior authorized identity disclosure by the RTA for each link | 2 |
| `record_implies_init` *(helper)* | Any ML record for a vehicle implies that vehicle was initialized first | 11 |
| `vid_privacy` *(helper)* | A vehicle's real identity is output only via `RTA_Reveal_Pseudonym`; it is otherwise unreachable by the adversary | 3 |
| `ml_acl_implies_reveal` *(helper)* | If a vehicle's identity is known and is in the ML, then the RTA must have previously authorized its disclosure | 4 |
| `auth_resolve` | Authorized identity traceability — the adversary can correctly link a pseudonym to a vehicle only if the RTA previously authorized disclosure of that vehicle's identity | 6 |
| `ppid_unlink` | Pseudonym unlinkability — linking two different pseudonyms to the same vehicle requires two separate authorized disclosures by the RTA | 2 |
| `ml_consistency` | Member list consistency — successive ML records for the same vehicle are separated by an expiration event (update, transfer, or validity-period expiry) | 59 |

---

## Execution

All proofs use `lbrcppa.spthy` with Tamarin Prover v1.10.0. Never run two Tamarin instances in parallel (memory exhaustion risk). A combined `--prove` run exceeds available memory (OOM-killed after ~160 min on a 64 GB machine); lemmas must be proved individually.

**Prove a specific lemma:**
```bash
tamarin-prover lbrcppa_v2.spthy --prove=<lemma_name> --derivcheck-timeout=120
```
Replace `<lemma_name>` with any lemma from the table above (e.g., `auth_resolve`, `ml_consistency`).

**Note on `[reuse]` helpers:** Tamarin injects `[reuse]`-annotated lemmas as axioms for all syntactically subsequent lemmas, regardless of proof order. This means individual lemma runs are independent — you can prove them in any order. However, the helper lemmas (`record_implies_init`, `vid_privacy`, `ml_acl_implies_reveal`, `auth_resolve`) must still be proved explicitly; without their own proof runs they are unverified assumptions.

**Proof order (matching file order):**
```bash
# Session lemmas (fast, ~40s each; no reuse axioms needed)
tamarin-prover lbrcppa_v2.spthy --prove=sess_valid_send --derivcheck-timeout=120
tamarin-prover lbrcppa_v2.spthy --prove=sess_valid_recv --derivcheck-timeout=120
tamarin-prover lbrcppa_v2.spthy --prove=ts_valid --derivcheck-timeout=120
tamarin-prover lbrcppa_v2.spthy --prove=sess_indep --derivcheck-timeout=120      # ~8 min
tamarin-prover lbrcppa_v2.spthy --prove=session_isolation --derivcheck-timeout=120  # ~8 min
# Helper lemmas (prove to close the reuse chain)
tamarin-prover lbrcppa_v2.spthy --prove=record_implies_init --derivcheck-timeout=120
tamarin-prover lbrcppa_v2.spthy --prove=ml_consistency --derivcheck-timeout=120  # ~8 min
tamarin-prover lbrcppa_v2.spthy --prove=vid_privacy --derivcheck-timeout=120
tamarin-prover lbrcppa_v2.spthy --prove=ml_acl_implies_reveal --derivcheck-timeout=120  # ~7 min
tamarin-prover lbrcppa_v2.spthy --prove=auth_resolve --derivcheck-timeout=120    # ~8 min
# Identity / unlinkability lemmas (benefit from auth_resolve [reuse])
tamarin-prover lbrcppa_v2.spthy --prove=x_sess_unlink --derivcheck-timeout=120
tamarin-prover lbrcppa_v2.spthy --prove=ppid_unlink --derivcheck-timeout=120
```

---

# Contact

For questions or collaboration:

**Tao-hsiang Chang**

e-mail: tchang@cs.nccu.edu.tw
