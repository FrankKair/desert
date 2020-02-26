## OCaml

This README file is a brief whirlwind tour of the language.


From [Wikipedia](https://en.wikipedia.org/wiki/OCaml):

```
OCaml features: a static type system, type inference, parametric polymorphism, tail recursion,
pattern matching, first class lexical closures, functors (parametric modules), exception handling,
and incremental generational automatic garbage collection.
```

---

### References

[Cornell CS3110 - Functional Programming in OCaml](https://www.cs.cornell.edu/courses/cs3110/2019fa/textbook/)

[Caltech CS134 - Introduction to Objective Caml](http://courses.cms.caltech.edu/cs134/cs134b/book.pdf)

[Real World OCaml](https://dev.realworldocaml.org/)

[Unix system programming in OCaml](https://github.com/ocaml/ocamlunix)

[Developing Applications with Objective Caml](https://caml.inria.fr/pub/docs/oreilly-book/html/index.html)

---

### General

Every OCaml function takes exactly one argument (auto currying).

```ocaml
(* These are equivalent *)
let add x y = x + y
let add = fun x -> (fun y -> x + y)
```

Pattern matching with match and function (no need for type annotations, since OCaml's inference is quite powerful).

```ocaml
let rec size (t: 'a tree): int =
  match t with
  | Empty -> 0
  | Node(l, _, r) -> 1 + (size l) + (size r)

let rec size = function
  | Empty -> 0
  | Node(l, _, r) -> 1 + (size l) + (size r)
```

### Lists and tuples

Tuples are the simplest aggregate data type in OCaml. Note the product type `int * string`.

```ocaml
let tuple = (1, "OCaml");;
(* val tuple : int * string = (1, "OCaml") *)

let (number, _) = tuple;;
(* val number : int = 1 *)
```

Lists are immutable, finite sequence of elements of the same type implemented as singly linked lists under the hood. Lists are parametrized and their type is `'a list`.

```ocaml
let l1 = [1; 2; 3;];;
(* val l1 : int list = [1; 2; 3] *)

(* @ operator -> List.append *)
[1; 2; 3] @ [4; 5; 6];;
(* - : int list = [1; 2; 3; 4; 5; 6] *)

(* :: operator -> cons *)
let l1 = 1 :: (2 :: (3 :: []));;
(* val l1 : int list = [1; 2; 3] *)

let rec size = function
  | []          -> 0
  | head::tail  -> 1 + (size tail);;
(* val size : 'a list -> int = <fun> *)

let rec map f = function
  | []          -> []
  | head::tail  -> f head :: map f tail;;
(* val map : ('a -> 'b) -> 'a list -> 'b list = <fun> *)
```

### Sum and product types

Variants = disjoint sets = sum types = one of a set of possibilities
```ocaml
type day = Sun | Mon | Tue | Wed | Thu | Fri | Sat 
```

Tuple/record = cartesian product = product types = each of a set of possibilities
```ocaml
(* Record example *)
type person = {name: string; age: int}
```

Algebraic data type = variant with both sum and product types
```ocaml
type point = {x: int; y: int}

type shape =
  | Point  of point
  | Circle of point * float 
  | Rect   of point * point

let area = function
  | Point _ -> 0.0
  | Circle (_, r) -> pi *. (r ** 2.0)
  | Rect ((x1, y1), (x2, y2)) ->
    let w = x2 -. x1 in
    let h = y2 -. y1 in
      w *. h
```

### References, Mutable State and Aliasing

`mutable` keyword plus `<-` operator.

```ocaml
type point = {mutable x: int; mutable y: int}

(* point -> int -> int -> unit *)
let shift p dx dy =
  p.x <- p.x + dx;
  p.y <- p.y + dy
```

References

```ocaml
val ref : 'a      -> 'a ref
val (:=): 'a ref  -> 'a     -> unit
val (!) : 'a ref  -> 'a
```

Equality

Structural equality operator `=`, recursively traverses the data structure to determine whether its arguments are equal.

Reference equality operator `==`, only looks at heap locations, so equates fewer things than structural equality.

### Modules

ADT -> Abstract data type (to be implemented by a data structure).

```ocaml
(* signature = interface *)
module type M = sig
  type 'a m

  val x: 'a m
end

(* struct = implementation *)
module MImpl : M = struct
  type 'a m = ...

  let x = ...
end
```
