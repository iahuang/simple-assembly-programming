# SAP+

_A superset of the Simple Assembly Language by Mr. Stulin_

Goal: To implement functionality that does not already exist in SAP but should be

## Expanded instruction set

---

### `call`

A versatile wrapper for `jsr`

#### Syntax:
```
call [subroutine] [arg1] [arg2] [arg3] ...
```
`arg1`, `arg2`, `arg3` get internally passed as `r1`, `r2`, and `r3` to the subroutine respectively

#### Passing Arguments:

`arg(n)` can exist in a number of forms.

`r1` passes the value of register 1

`*r1` treats r1 as a pointer and passes its underlying value

`&label` passes the address of label `label`

`*label` passes the integer value of label `label`

---

### `movim`
Syntax: `movim #0 label`

---

## Differences in syntax

- Labels do not need to have an instruction immediately following them

Example:
```
mysubroutine:
    movir #1 r1
    addir #213 r2
```
is valid in SAP+