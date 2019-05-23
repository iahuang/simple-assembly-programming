# SAP+

_A superset of the Simple Assembly Language by Mr. Stulin_

Goal: To implement functionality that does not already exist in SAP but should be

---

## SAP+ Arguments

Values in SAP+ can exist in a number of forms.

`r1` passes the value of register 1

`*r1` treats r1 as a pointer and passes its underlying value

`&label` passes the address of label `label`

`*label` passes the integer value of label `label`

These arguments can be used in most SAP+ expressions such as if statements, shorthand assignment, etc., but _cannot_ be used in a default SAP instruction. For instance `movrm r1 &label` is illegal.

## Syntax extensions

---

### `call`

A versatile wrapper for `jsr`

#### Syntax:
```
call [subroutine] [arg1] [arg2] [arg3] ...
```
`arg1`, `arg2`, `arg3` get internally passed as `r1`, `r2`, and `r3` to the subroutine respectively. `arg` can take the form of any SAP+ argument.

---

### `if / else`

Easier branching code in SAP

#### Syntax:

```
if [condition]
    movir #23 r4
    movrr r1 r2
else
    addir #1 r2
endif
```
- `else` branch is not required
- `else if` is currently not supported
- Condition can only follow the form `a ** b`, at the moment, where `a` and `b` are generic SAP+ arguments, and `**` represents one of the following comparators:
  - ==
  - !=
  - \>
  - <
  - \>=
  - <=
- Nested if statements are supported

---

### `print` and `println`

Easier debugging and readibility for SAP

#### Syntax:

Prints arguments 1...n separated by spaces and closes with a newline character
```
println [arg1] [arg2] [arg3] ...
```
Prints arguments 1...n separated by spaces without a newline character
```
print [arg1] [arg2] [arg3] ...
```


---

## Expanded instruction set

### `movim #1 label`
### `movmm label label`
### `addim #1 label`
### `addrx r1 r2`
### `subim #1 label`

## Differences in syntax

- Labels do not need to have an instruction immediately following them

Example:
```
mysubroutine:
    movir #1 r1
    addir #213 r2
```
is valid in SAP+