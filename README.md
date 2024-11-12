# LB-RCPPA Formal Verification

Formal verification of Lattice-Based Ring-based Conditional Privacy-Preserving Authentication protocol using EasyCrypt and Tamarin.

## Structure

```bash
project/
├── easycrypt/                      # EasyCrypt proofs and related files
│   ├── problems/                   # Definitions of hard mathematical problems used in the protocol
│   │   ├── SISProblem.ec           # Formal definition of the Short Integer Solution (SIS) problem
│   │   ├── ISISProblem.ec          # Formal definition of the Inhomogeneous Short Integer Solution (ISIS) problem
│   │   └── BiGISISProblem.ec       # Formal definition of the Bilateral Generalization of the ISIS (Bi-GISIS) problem
│   ├── primitives/                 # Implementations of cryptographic primitives based on the hard problems
│   │   ├── Common.ec               # Common definitions and parameters used across primitives
│   │   ├── TrapdoorFunctions.ec    # Definitions and implementations of lattice trapdoor functions
│   │   ├── Ring.ec                 # Implementation of the lattice-based ring signature scheme
│   │   ├── KeyExchange.ec          # Implementation of the Bi-GISIS key exchange protocol
│   │   ├── HashFunctions.ec        # Definitions of cryptographic hash functions used in the protocol
│   │   └── Utils.ec                # Utility functions and helper definitions used throughout the primitives
│   ├── proofs/                     # Proofs of security properties for the cryptographic primitives
│   │   ├── SecurityReductions.ec   # Common security reductions used in multiple proofs
│   │   ├── ring/                   # Proofs related to the ring signature scheme
│   │   │   ├── Unforgeability.ec   # Proof of unforgeability (EUF-CMA) for the ring signature
│   │   │   ├── Anonymity.ec        # Proof of anonymity for the ring signature
│   │   │   └── NonRepudiation.ec   # Proof of non-repudiation for the ring signature
│   │   └── keyexchange/            # Proofs related to the key exchange protocol
│   │       ├── KeySecurity.ec      # Proof of key security (indistinguishability) for the key exchange
│   │       ├── KeyReusability.ec   # Proof of key reusability security for the key exchange
│   │       └── ForwardSecurity.ec  # Proof of forward security for the key exchange
│   └── lemmas/                     # Auxiliary lemmas and mathematical results used in the proofs
│       ├── SISLemmas.ec            # Lemmas specific to the SIS problem
│       ├── ISISLemmas.ec           # Lemmas specific to the ISIS problem
│       ├── BiGISISLemmas.ec        # Lemmas specific to the Bi-GISIS problem
│       ├── LatticeOps.ec           # Lemmas and definitions for lattice operations
│       ├── GaussianSampling.ec     # Lemmas and definitions for Gaussian sampling techniques
│       ├── HashFunctionLemmas.ec   # Lemmas related to the properties of hash functions
│       └── MathLemmas.ec           # General mathematical lemmas used across various proofs
├── tamarin/                        # Tamarin models and proofs
│   ├── protocol/                   # Tamarin models of the protocol's operational behavior
│   │   ├── Setup.spthy             # Model of the initial setup phase of the LB-RCPPA protocol
│   │   ├── States.spthy            # Definitions of protocol states and state transitions
│   │   ├── PseudonymSystem.spthy   # Model of the pseudonym system and pseudonym updates
│   │   ├── MemberList.spthy        # Model of member list management and updates by the RTA
│   │   └── SharesProduction.spthy  # Model of the vehicle shares production phase
│   ├── properties/                 # Specifications and proofs of security properties to be verified
│   │   ├── Authentication.spthy    # Specifications and proofs of authentication properties
│   │   ├── Privacy.spthy           # Specifications and proofs of privacy and anonymity properties
│   │   ├── MessageSecurity.spthy   # Specifications and proofs of message integrity and confidentiality
│   │   ├── UpdateSecurity.spthy    # Specifications and proofs related to update and reauthentication security
│   │   └── Consistency.spthy       # Specifications and proofs of protocol consistency and correctness
│   └── lemmas/                     # Auxiliary lemmas and definitions used in the Tamarin proofs
│       ├── StateTransition.spthy   # Lemmas related to state transitions and protocol flows
│       ├── AuthLemmas.spthy        # Lemmas supporting authentication properties
│       ├── PrivacyLemmas.spthy     # Lemmas supporting privacy and anonymity properties
│       ├── MessageLemmas.spthy     # Lemmas supporting message security properties
│       └── TimeLemmas.spthy        # Lemmas related to timing aspects and replay resistance