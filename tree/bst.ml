open Stdio

(* A complete, balanced binary tree of height h has 2h − 1 nodes,
   or, conversely if there are n nodes, then the tree height is log2 n *)
type 'a tree =
  | Empty
  | Node of 'a tree * 'a * 'a tree

let leaf x = Node(Empty, x, Empty)

(* Assumes it is not a binary search tree *)
let rec contains x = function
  | Empty -> false
  | Node(l, value, r) -> value = x || (contains x l) || (contains x r)

(* Binary search tree invariant *)
let rec lookup x = function
  | Empty -> false
  | Node(l, value, r) ->
    if value = x then true
    else if value < x then lookup x l
    else lookup x r

let rec insert x = function
  | Empty -> Node(Empty, x, Empty)
  | Node(l, value, r) ->
    if x < value then Node(insert x l, value, r)
    else Node(l, value, insert x r)

let rec size = function
  | Empty -> 0
  | Node(l, _, r) -> 1 + (size l) + (size r)

(* height = depth *)
let rec height = function
  | Empty -> 0
  | Node(l, _, r) -> 1 + max (height l) (height r)

let rec max t = 
  match t with
  | Empty -> failwith "max called on empty tree"
  | Node(_, value, Empty) -> value 
  | Node(_, _, r) -> max r

let rec min t = 
  match t with
  | Empty -> failwith "min called on empty tree"
  | Node(Empty, value, _) -> value 
  | Node(l, _, _) -> min l

let rec inorder = function
  | Empty -> []
  | Node(l, n, r) -> inorder l @ [n] @ inorder r

let rec preorder = function
  | Empty -> []
  | Node(l, n, r) -> [n] @ preorder l @ preorder r

let rec postorder = function
  | Empty -> []
  | Node(l, n, r) -> postorder l @ postorder r @ [n] 


let example =
  Node(Node(leaf 0,
            2,
            leaf 1),
       3,
       Node(leaf 3,
            2,
            leaf 1))

let another_tree = Node(Empty, 1, Empty)
                   |> insert 5
                   |> insert 6
                   |> insert 2

let () =
  let t1 = inorder example in
  let t2 = inorder another_tree in
  List.iter (printf "%i->") t1;
  print_newline ();
  List.iter (printf "%i =>") t2;
  print_newline ();
  printf "Max %i" (max another_tree);
  print_newline ();
  printf "Min %i" (min another_tree);
