open Parseur
open State
open Config

module P = Parseur
module S = State
module C = Config



(*let rec executer_aux (state : S.state) (config: C.config) = *)
  

(*

let rec executer_aux (config : C.config) =
  match config with
  |C.Inter(instr, s) ->  (executer_aux (C.faire_un_pas instr s)) (* in (C.printConfig a)*)
  |C.Final(s) -> S.End


let executer (funct : string) =
  let list_funct = P.list_of_string funct in
  let (instr, l) = P.p_S list_funct in
  let config = C.Inter(instr, (S.State('a', 0, (State('b', 0, (State('c', 0, End))))))) in
  (executer_aux config)


let _ = print_string "TEST avec While(1){a:=1}\n"
let condW = "w(1)"
let corpsW = "{"^"a:=1"^"}"
let m_While = condW^corpsW
let test_executer = executer m_While
 *)



let _ = print_string "TEST avec While(1){a:=1}\n"
let condW = "w(1)"
let corpsW = "{"^"a:=1"^"}"
let m_While = condW^corpsW
let list_While = P.list_of_string m_While
let (instr, l) = P.p_S list_While
let config = C.Inter(instr, (S.State('a', 0, (State('b', 0, (State('c', 0, End)))))))



