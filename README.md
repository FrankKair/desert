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

[Purely functional data structures in OCaml](https://github.com/mmottl/pure-fun)

---

### Stdlib

[Stdlib](https://caml.inria.fr/pub/docs/manual-ocaml/libref/Stdlib.html) (previously Pervasives) is automatically opened in every OCaml program.

### Functions

Every OCaml function takes exactly one argument (auto currying).

```ocaml
(* These are equivalent *)
let add x y = x + y
let add = fun x -> (fun y -> x + y)
```

Pattern matching with match and function (no need for type annotations, since OCaml's inference is quite powerful).

```ocaml
(* `'a` - tick alpha - is called a type variable, expressing that the type is generic *)
let rec size (t: 'a tree): int =
  match t with
  | Empty -> 0
  | Node(l, _, r) -> 1 + (size l) + (size r)

let rec size = function
  | Empty -> 0
  | Node(l, _, r) -> 1 + (size l) + (size r)
```

And here's an example of a labelled argument that is also optional with a default value.

```ocaml
let concat ?(sep="") x y = x ^ sep ^ y;;
(* val concat : ?sep:string -> string -> string -> string = <fun> *)

concat "foo" "bar";;
(* string = "foobar" *)

concat ~sep:":" "foo" "bar";;
(* string = "foo:bar" *)
```

### Lists and tuples

Tuples are the simplest aggregate data type in OCaml. Note the product type `int * string`. `*` is used in the type because that type corresponds to the set of all pairs containing one value of type int and one of type string. In other words, it’s the Cartesian product of the two types, which is why we use `*`, the symbol for product.

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

We've used Lists with functional patterns and now we're going to see some imperative programming with mutable data structures in OCaml. The simplest being the Array:

```ocaml
let nums = [|1; 2; 3; 4|];;
nums.(2) <- 4;;
(* unit = () *)
(* unit is like void in other languages *)

nums;;
(* int array = [|1; 2; 4; 4|] *)
```

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

### Data Structures

Comparison of OCaml built-in [data structures](https://ocaml.org/learn/tutorials/comparison_of_standard_containers.html) performance. Here's a tl;dr:

- Lists: immutable singly-linked lists;
- Arrays: mutable vectors;
- Strings: immutable vectors;
- Set and Map: immutable trees;
- Hashtbl: automatically growing hash table (mutable);
- Buffer: extensible (mutable) strings;
- Queue: mutable FIFO;
- Stack: mutable LIFO.

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
