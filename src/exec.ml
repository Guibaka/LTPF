open Parseur
open State
open Config

module P = Parseur
module S = State
module C = Config

let exp1 = "a:=1"
let test_exp1 = P.list_of_string exp1
let ranalist_exp1 = P.p_S test_exp1
let (ast, l) = ranalist_exp1
let _ = P.printInstr ast

let s = S.End
let c = (C.faire_un_pas ast s)
let _ = C.printConfig c

let condIf = "i(c)"
let corpsIf1 = "{c:=0;a:=b}"
let corpsIf2 = "{b:=0;c:=a}"
let m_If = condIf^corpsIf1^corpsIf2
let test_If = P.list_of_string m_If
let ranalist_If = P.p_I  test_If
let (ast, l) = ranalist_If
let _ = P.printInstr ast

let condW = "w(a)"
let corpsW = "{"^m_If^"}"
let m_While = condW^corpsW
let test_While = P.list_of_string m_While
let ranalist_While = P.p_I test_While
let (ast, l) = ranalist_While
let _ = P.printInstr ast
