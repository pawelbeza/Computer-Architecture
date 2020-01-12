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

**2. [x86 Architecture](https://en.wikipedia.org/wiki/X86)**

Language*: [NASM](https://en.wikipedia.org/wiki/Netwide_Assembler)

*Task*:
>Write hybrid program consisting of the main module in [ANSI C](https://en.wikipedia.org/wiki/C_(programming_language)) providing input and output as well as assembly language module which provides function formatdec which is subset of function [sprintf](http://www.cplusplus.com/reference/cstdio/sprintf/) which enables to format a single decimal number with support for all fixed format specifications. Rest of characters of the string should be treated as text which should be copied to the output string.

*Example*:

>input: ./formatdec "Input number is equal to %d" 150

>output: Input number is equal to 150

Solution to the aformentioned task was implemented in 32 bit as well as in 64 bit Assembler. Main differences between those two versions was that in 64 bit Assembler I didn't have to use callee saved registers because in 64 bit Assembler there are more registers which are not saved by the calee. Thanks to that I used less memory on stack comparing to the 32 bit version.

Implemented function enables specifying width(minimum number of characters to be printed) as well as following flags:

1. **-** Left-justify within the given field width; Right justification is the default (see width sub-specifier).
2. **+** Forces to precede the result with a plus or minus sign (+ or -) even for positive numbers. By default, only negative numbers are preceded with a -ve sign.
3. **(space)** If no sign is going to be written, a blank space is inserted before the value.
4. **0** Left-pads the number with zeroes (0) instead of spaces, where padding is specified (see width sub-specifier).
