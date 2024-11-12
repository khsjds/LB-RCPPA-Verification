# LB-RCPPA Formal Verification

Formal verification of Lattice-Based Ring-based Conditional Privacy-Preserving Authentication protocol using EasyCrypt and Tamarin.

## Structure

```bash
project/
├── easycrypt/        # EasyCrypt proofs
│   ├── Ring.ec      # Ring signature definitions
│   ├── SISProblem.ec # SIS problem definitions
│   └── RingUnforge.ec # Unforgeability proof
├── tamarin/          # Tamarin proofs
│   ├── Protocol.spthy # Protocol rules
│   └── Properties.spthy # Security properties