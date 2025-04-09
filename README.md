# LB-RCPPA Formal Verification

Formal verification of Lattice-Based Ring-based Conditional Privacy-Preserving Authentication protocol using EasyCrypt and Tamarin.

## Structure

```bash
project/
├── easycrypt/                      # EasyCrypt proofs and related files
│   ├── problems/                   # Definitions of hard mathematical problems used in the protocol
│   │   ├── SISProblem.ec
│   │   ├── ISISProblem.ec
│   │   └── BiGISISProblem.ec
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
│   │   │   ├── Anonymity.ec
│   │   │   └── NonRepudiation.ec
│   │   └── keyexchange/            # Proofs related to the key exchange protocol
│   │       ├── KeySecurity.ec      # Proof of key security (indistinguishability) for the key exchange
│   │       ├── KeyReusability.ec
│   │       └── ForwardSecurity.ec
│   └── lemmas/                     # Auxiliary lemmas and mathematical results used in the proofs
│       ├── SISLemmas.ec
│       ├── ISISLemmas.ec
│       ├── BiGISISLemmas.ec
│       ├── LatticeOps.ec
│       ├── GaussianSampling.ec
│       ├── HashFunctionLemmas.ec
│       └── MathLemmas.ec
└── tamarin/                        # Tamarin models and proofs
│   ├── lib/
│   │   ├── common.spthy       # Common functions, types, and reusable rules
│   │   └── crypto.spthy       # Cryptographic primitives and assumptions
│   ├── models/
│   │   ├── setup.spthy        # System setup and registration
│   │   ├── keyexchange.spthy  # Key exchange protocol rules
│   │   ├── signature.spthy    # Ring signature rules
│   │   ├── messages.spthy     # Message handling rules  
│   │   └── updates.spthy      # Pseudonym/member list update rules
│   ├── properties/
│   │   ├── authentication.spthy  # Authentication properties
│   │   ├── privacy.spthy        # Privacy and anonymity properties
│   │   ├── freshness.spthy      # Message freshness properties
│   │   └── states.spthy         # State transition properties
└── README.md           # Documentation and instructions