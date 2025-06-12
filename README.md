# LB-RCPPA Formal Verification Repository
This repository contains the Tamarin Prover models for formally verifying the security properties of the **Lattice-Based Ring Signature-Based Conditional Privacy Preserving Authentication (LB-RCPPA)** protocol.

LB-RCPPA is a lattice-based authentication and privacy-preserving framework designed for secure communications in Vehicular Ad Hoc Networks (VANETs). The formal models verify the security properties of LB-RCPPA under post-quantum assumptions.  

The Tamarin models provided here serve as the formal verification framework supporting the theoretical security proofs presented in the LB-RCPPA research, using Tamarin Prover v1.10.0.

---

# Repository Structure
```bash
LB-RCPPA-VERIFICATION/
├── old/                   # Archived or earlier versions of Tamarin models and testing files
├── lbrcppa.spthy          # Current finalized Tamarin model for LB-RCPPA
└── README.md              # This file
```
The directory old/ contains development versions, experimental models, and historical copies of previous lbrcppa.spthy. The latest copy of lbrcppa.spthy always corresponds to the most updated model (currently synchronized with lbrcppa05.spthy).

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

## Verified Security Properties

The models verify several key security properties relevant to VANET environments, including:

- **Mutual Authentication**  
- **Session Key Freshness and Agreement**  
- **Anonymity and Message Unlinkability**  
- **Authorized Identity Traceability**  
- **Binding Preservation for Membership Resolution**  
- **Forward Security for Credential Updates**  
- **Resistance to Replay Attacks and Key Reuse**

## Execution
- Currently we're using the following command to start the proving process: 
```bash
tamarin-prover --prove lbrcppa.spthy --derivcheck-timeout=120 -c=30
```

- Due to the complex Member List life cycle, the lemma ml_consistency is proven separately:
  1. **Prove all lemmas except ml_consistency**:
   Comment out lemma ml_consistency and restriction max_recordml (lines 853-879)
  2. **Prove ml_consistency**:
   Comment out all other lemmas (lines 778-851), enable ml_consistency and restriction max_recordml

---

# Contact

For questions or collaboration:

**Tao-hsiang Chang**

e-mail: tchang@cs.nccu.edu.tw