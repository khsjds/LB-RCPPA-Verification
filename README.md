# LB-RCPPA Formal Verification Repository
This repository contains the Tamarin Prover models for formally verifying the security properties of the **Lattice-Based Ring Signature-Based Conditional Privacy Preserving Authentication (LB-RCPPA)** protocol.

LB-RCPPA is a lattice-based authentication and privacy-preserving framework designed for secure communications in Vehicular Ad Hoc Networks (VANETs). The formal models verify the security properties of LB-RCPPA under post-quantum assumptions.

The Tamarin models provided here serve as the formal verification framework supporting the theoretical security proofs presented in the LB-RCPPA research, using Tamarin Prover v1.10.0.

---

# Repository Structure
```bash
LB-RCPPA-VERIFICATION/
├── Archived/              # Previous versions of Tamarin models and experimental files
├── lbrcppa.spthy          # Current finalized Tamarin model for LB-RCPPA
└── README.md              # This file
```
The `Archived/` directory contains development and historical versions. The latest `lbrcppa.spthy` always corresponds to the most current verified model.

---

# Model Description
The formal Tamarin model reflects the six protocol phases designed in LB-RCPPA:

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

The Tamarin model specifies the protocol logic, message flows, and adversary interactions across all six phases.

## Modelling Notes

- **Ring size**: The model uses a ring of size p=3 (one signer + two public ring members) for source precomputation tractability. Privacy properties are independent of ring cover size.
- **Ring member sourcing**: Ring members 2 and 3 are sourced via `In()` — their public keys are network-observable, which is the correct Dolev-Yao treatment. The signer's key is bound to the persistent `!V_Sig_Keys` fact.
- **Session key abstraction**: Session keys (`ki`) are modelled as fresh nonces (`Fr(~ki)`), abstracting the Bi-GISIS key exchange computation without introducing symbolic equation triggers.
- **Heuristics**: `session_key_secrecy` and `recordml_transition` use `[heuristic=I]` (oldest-goal-first) to prevent proof-search divergence on adversary-supplied terms.

## Verified Security Properties

The model verifies the following security properties (16 lemmas total):

| Lemma | Description |
|-------|-------------|
| `sess_valid_send` | Messages sent only under a valid session |
| `sess_valid_recv` | Messages received only under a valid session |
| `ts_valid` | Timestamps valid when verified |
| `sess_indep` | Distinct pseudonyms carry distinct session keys |
| `session_isolation` | Session keys remain distinct even when both are compromised |
| `session_key_secrecy` | Adversary cannot learn session key without explicit compromise |
| `regattempt_implies_init` | Registration requires prior vehicle initialization |
| `record_implies_init` | ML records imply prior vehicle initialization |
| `vid_privacy` | Vehicle real identity known only via authorized RTA reveal |
| `ml_acl_implies_reveal` | ML-recorded identity requires prior RTA disclosure |
| `ml_consistency` | Successive ML records separated by expiration events |
| `auth_resolve` | Pseudonym-to-vehicle links require prior RTA authorization |
| `expireml_implies_witness` | Every ML expiration has a specific typed witness |
| `recordml_transition` | ML lifecycle transitions are well-ordered |
| `x_sess_unlink` | Cross-session pseudonym links require per-link RTA authorization |
| `ppid_unlink` | Pseudonym unlinkability: each link requires separate RTA authorization |

---

# Execution

Full verification (all 16 lemmas):

```bash
tamarin-prover lbrcppa.spthy --prove --auto-sources \
  --derivcheck-timeout=0 +RTS -M32G -N4 -RTS
```

**Resource requirements**: approximately 32 GB peak RAM, several hours of CPU time.

To prove a single lemma:

```bash
tamarin-prover lbrcppa.spthy --prove=<LEMMA_NAME> --auto-sources \
  --derivcheck-timeout=0 +RTS -M32G -N4 -RTS
```

Recommended proof order (dependencies): trivials → `session_key_secrecy` → `regattempt_implies_init` → `record_implies_init` → `expireml_implies_witness` → `recordml_transition` → remaining lemmas.

---

# Contact

For questions or collaboration:

**Tao-hsiang Chang**

e-mail: tchang@cs.nccu.edu.tw
