# ARKO - Computer Architecture
Course covers theoretical foundations of computer architecture, as well as principles of constructing program models of processors and lists of instructions, implementation of high-level languages, principles of processor operation, construction of memory hierarchy and systemic aspects of processor architecture. 

---
**1. [MIPS Architecture](https://en.wikipedia.org/wiki/MIPS_architecture)**

*Language*: MIPS Assembly

*Environment*: [MARS](https://courses.missouristate.edu/KenVollmar/MARS/features.htm) (MIPS Assembler and Runtime Simulator)

*Task*:
>Write program which sums fixed-digit numbers in decimal format which are read from the console. Number can have up to 200 digits.

*Solution*:

Since numbers can have up to 200 digits they may not fit into register. 
Therefore I read input numbers as sequences of characters and perform the column method of addition.
