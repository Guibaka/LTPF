(*
On continue le TP de la dernière fois. On cherche toujours
à analyser des programmes comme

a:=1;
b:=1;
c:=1;
w(a){
 i(c){
  c:=0;
  a:=b
 }{
  b:=0;
  c:=a
 }
}

à l'aide d'une grammaire (définissant le langage while):

V pour variable1
C pour constante
E pour expression
I pour instruction

S pour axiome (tradition dans les grammaires)
L pour liste d'instructions

  S ::= IL | ε
  L ::= ;S | ε
  I ::= V:=E | i.E{S}{S} | w.E{S} | ε

 *)

module Parseur = 
struct
type v = A | B | C | D
type c = Zero | Un
type exp = Var of v | Cst of c
type instr =
  | Skip
  | Assign of exp * exp
  | If of exp * instr * instr
  | While of exp * instr
  | Seq of instr * instr

(* Le type des fonctions qui épluchent une liste de terminaux *)
type 't analist = 't list -> 't list
(* Le type des fonctions qui épluchent une liste et rendent un résultat *)
type ('r, 't) ranalist = 't list -> 'r * 't list  (*  l ---> (elt, suite_liste   )    *)
(* Un type commun pour 't analist ou ('r, 't) ranalist *)
type ('x, 't) st = 't list -> 'x

type 'p listP = unit -> 'p suite
and 'p suite = Nil | Cons of 'p * 'p listP


let list_of_string s =
  let rec boucle s i n =
    if i = n then [] else s.[i] :: boucle s (i+1) n
  in boucle s 0 (String.length s)

exception Echec

(* a suivi de b, ce dernier pouvant rendre un résultat *)
let (+>) (a : 't analist) (b : ('x, 't) st) : ('x, 't) st =
  fun l -> let l = a l in b l

(* a rendant un résultat suivi de b, ce dernier pouvant rendre un résultat *)
let (++>) (a : ('r, 't) ranalist) (b : 'r -> ('x, 't) st) : ('x, 't) st =
  fun l -> let (x, l) = a l in b x l

(* Choix entre a ou b *)
let (+|) (a : ('x, 't) st) (b : ('x, 't) st) : ('x, 't) st =
  fun l -> try a l with Echec -> b l

let return : 'r -> ('r, 't) ranalist = fun x l -> (x,l)


let terminal c : 't analist = fun l -> match l with
                                       | x :: l when x = c -> l
                                       | _ -> raise Echec


let p_E : ('r, 't) ranalist = fun l ->
  match l with
  |'a' :: l -> (Var(A), l)
  |'b' :: l -> (Var(B), l)
  |'c' :: l -> (Var(C), l)
  |'d' :: l -> (Var(D), l)
  |'1' :: l -> (Cst(Un), l)
  |'0' :: l -> (Cst(Zero), l)
  |_ -> raise Echec

let p_V : ('r, 't) ranalist = fun l ->
  match l with
  |'a' :: l -> (Var(A), l)
  |'b' :: l -> (Var(B), l)
  |'c' :: l -> (Var(C), l)
  |'d' :: l -> (Var(D), l)
  |_-> raise Echec


(*S ::= IL | ε
  L ::= ;S | ε
  I ::= V:=E | i.E{S}{S} | w.E{S} | ε*)

let rec p_S : (instr, char) ranalist = fun l->
  l |>
    (p_I ++> fun a -> p_L ++> fun b -> return (Seq(a,b)))
    +|
      (return Skip)
  and
    p_L : (instr, char) ranalist = fun l ->
    l |>
      (terminal ';' +> p_S ++> fun a -> (return a))
      +|
        (return(Skip))
  and
    p_I : (instr, char) ranalist = fun l ->
    l |>
      ( p_V ++>
         fun a-> terminal ':' +> terminal '=' +> p_E ++>
                   fun b -> (return (Assign(a,b))))
      +|
        (terminal 'i' +>  terminal '(' +> p_E ++>
           fun a -> terminal ')' +> terminal '{' +> p_S ++>
                      fun b -> terminal '}' +> terminal '{' +> p_S ++>
                                 fun c -> terminal '}' +> (return (If(a,b,c))))
      +|
        (terminal 'w' +> terminal '(' +> p_E ++>
           fun a -> terminal ')' +> terminal '{' +>  p_S ++>
                      fun b -> terminal '}' +> (return (While(a,b))))
      +|
        (return Skip)
end


(* TEST du module Parseur *)

let exp1 = "a:=1;"
let test_exp1 = Parseur.list_of_string exp1
let ranalist_exp1 = Parseur.p_S test_exp1

let exp2 = "b:=1;"
let test_exp2 = Parseur.list_of_string exp2
let ranalist_exp2 = Parseur.p_S test_exp2

let exp3 = "c:=1;"
let test_exp3 = Parseur.list_of_string exp3
let ranalist_exp3 = Parseur.p_S test_exp3

let condIf = "i(c)"
let corpsIf1 = "{c:=0;a:=b}"
let corpsIf2 = "{b:=0;c:=a}"
let m_If = condIf^corpsIf1^corpsIf2
let test_If = Parseur.list_of_string m_If
let ranalist_If = Parseur.p_I  test_If

let condW = "w(a)"
let corpsW = "{"^m_If^"}"
let m_While = condW^corpsW
let test_While = Parseur.list_of_string m_While
let ranalist_While = Parseur.p_I test_While

let test_fun = exp1^exp2^exp3^m_While
let list_test_fun = Parseur.list_of_string test_fun
let ranalist_Fonct = Parseur.p_S list_test_fun