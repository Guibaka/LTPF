open Parseur
open State
open Config

module P = Parseur
module S = State
module C = Config









let rec executer_aux (config : C.config) =
  match config with
  |C.Inter(instr, s) ->  let a = (executer_aux (C.faire_un_pas instr s))  in (C.printConfig a); a
  |C.Final(s) -> config


let executer (funct : string) =
  let list_funct = P.list_of_string funct in
  let (instr, l) = P.p_S list_funct in
  let config = C.Inter(instr, (S.State('a', 0, (State('b', 0, (State('c', 0, End))))))) in
  (executer_aux config)




let _ = print_string "TEST avec While(1){a:=1}\n"
let deb = "a:=1;"
let condW = "while(a)"
let corpsW = "{"^"a:=0"^"}"
let m_While = deb^condW^corpsW
let test_executer = executer m_While
let _  = print_string "END TEST \n \n"


let _ = print_string "TEST avec a:=1; b:=0; c:=1\n"
let inita = "a:=1;"
let initb = "b:=0;"
let initc = "c:=1"
let m_Assign = inita^initb^initc
let test_executer = executer m_Assign
let _ = print_string "END TEST \n \n"




(*
let _ = print_string "TEST avec While(1){a:=1}\n"
let condW = "w(1)"
let corpsW = "{"^"a:=1"^"}"
let m_While = condW^corpsW
let list_While = P.list_of_string m_While
let (instr, l) = P.p_S list_While
let config = C.Inter(instr, (S.State('a', 0, (State('b', 0, (State('c', 0, End)))))))

 *)

