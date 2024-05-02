# EVALUATE ARITHMETIC EXPRESSIONS PROJECT
In this small project, I'm implementing a parser that will parse arithmetic expressions and evaluate them!


This is a part of my bigger project which is the **DJOLANG** which will be a programming language made for educational purposes!

##

## PROJECT STRUCTURE

```
├── bin
    ├── del.sh
    ├── main
    ├── make.sh
    └── run.sh

├── src
    ├── astf.pas
    ├── errorf.pas
    ├── evaluatef.pas
    ├── graphf.pas
    ├── lexerf.pas
    ├── main.pas
    ├── parserf.pas
    ├── pfile.pas
    ├── ptypef.pas
    ├── queuef.pas
    ├── string_viewf.pas
    ├── test.pas
    └── tokenizerf.pas

├── README.md
```

##

## EXPLANATION

You'll find in the **src** directory the files needed for the implementation of this parser!

**string_viewf.pas** : contains the implementation of the string view data structure needed in lexing the user input!

**lexerf.pas** : contains the lex function which will take the user input and return a sequence of tokens needed for parsing!

**parserf.pas** : contains the functions nedded for parsing user input and generating the abstract syntax tree!

**astf.pas** : contains the constructors of the AST nodes!


## Getting Started

Follow these instructions to compile and run the programs:

### Prerequisites

- **FREE PASCAL COMPILER**: Make sure you have **fpc** installed to compile the [**PASCAL**](https://www.freepascal.org/) programs.

### Compilation

To compile the programs, use the following commands in your terminal:

```bash
$ cd bin
$ ./make.sh
```


## Usage

#### EXECTUING
After compiling, run the programs as follows:
```bash
$ ./run.sh
```



## AUTHOR
BOUHADDA MOHAMMED DJAOUED


