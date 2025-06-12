# LB-RCPPA Formal Verification Repository
This repository contains the Tamarin Prover models for formally verifying the security properties of the **Lattice-Based Ring Signature-Based Conditional Privacy Preserving Authentication (LB-RCPPA)** protocol.

LB-RCPPA is a lattice-based authentication and privacy-preserving framework designed for secure communications in Vehicular Ad Hoc Networks (VANETs). The formal models verify the security properties of LB-RCPPA under post-quantum assumptions.  

The Tamarin models provided here serve as the formal verification framework supporting the theoretical security proofs presented in the LB-RCPPA research, using Tamarin Prover v1.10.0.

- Currently we're using the following command to start the proving process: 
tamarin-prover --prove lbrcppa.spthy --derivcheck-timeout=120 -c=30

- Since the Memeber List life cycle is complex and different kinds of looping occurs, we prove lemma ml_consistency separately -- that is, we comment out lemma ml_consistency and restriction max_recordml (ln:853-879) to run all other lemmas, and comment out all other lemmas (ln:778-851) to run lemma ml_consistency along with restriction max_recordml. 

---

# Repository Structure
LB-RCPPA-VERIFICATION/
├── old/                   # Archived or earlier versions of Tamarin models and testing files
├── lbrcppa.spthy          # Current finalized Tamarin model for LB-RCPPA
└── README.md              # This file

Directory "old" contains all used examples/past versions of models. There'll always be a copy of current lbrcppa.spthy in the old folder (currently lbrcppa05.spthy)

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

---

## Verified Security Properties

The models verify several key security properties relevant to VANET environments, including:

- **Mutual Authentication**  
- **Session Key Freshness and Agreement**  
- **Anonymity and Message Unlinkability**  
- **Authorized Identity Traceability**  
- **Binding Preservation for Membership Resolution**  
- **Forward Security for Credential Updates**  
- **Resistance to Replay Attacks and Key Reuse**