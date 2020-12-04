open Parseur
open State
open Config

module P = Parseur
module S = State
module C = Config

let rec printList (l : char list) =
  match l with
  |a::suite -> let _ = (print_char a) in (printList suite)
  |[] -> (print_char ' ')
  


let rec executer_aux (config : C.config) (nbPas : int) =
  let _ = (print_string "\n \n \n \n \n"); read_line () in 
  match config with
  |C.Inter(instr, s) -> let _ = (print_string "Step :\n") ; (print_int nbPas) ; (print_string "\n \n" ) in let _ = (print_string "Sate :\n") ; (S.printState s) in let _ = (print_string "Instruction :\n ");(P.printInstr instr) in  (executer_aux (C.faire_un_pas instr s) (nbPas+1)) 
  |C.Final(s) -> (config, nbPas)




let executer (funct : string) =
  let list_funct = P.list_of_string funct in
  let (instr, l) = P.p_S list_funct in
  let config = C.Inter(instr, (S.State('a', 0, (State('b', 0, (State('c', 0, End))))))) in
  let (config, nbPas) = (executer_aux config 0) in (print_string "Nombre de pas total: "); (print_int nbPas); (print_string "\n")



let _ = print_string "TEST avec While(1){a:=1}\n"
let deb = "a:=1;"
let condW = "while(a)"
let corpsW = "{"^"a:=0"^"}"
let m_While = deb^condW^corpsW
let test_executer = executer m_While
let _  = print_string "END TEST \n \n \n \n \n \n \n \n\n \n"


let _ = print_string "TEST avec a:=1; b:=0; c:=a\n"
let inita = "a:=1;"
let initb = "b:=0;"
let initc = "c:=a"
let m_Assign = inita^initb^initc
let test_executer = executer m_Assign
let _ = print_string "END TEST \n \n \n \n \n \n \n \n\n \n"


let _ = print_string "TEST avec If(1){a:=1;b:=a}{a:=1; c:=a}\n"
let condI = "if(1)"
let corpsI1 = "{a:=1;b:=a}"
let corpsI2 = "{a:=1;c:=a}"
let m_If = condI^corpsI1^corpsI2
let test_executer = executer m_If
let _ = print_string "END TEST \n \n \n \n \n \n \n \n\n \n"


let _ = print_string "TEST avec If(0){a:=1;b:=a}{a:=1; c:=a}\n"
let condI = "if(0)"
let corpsI1 = "{a:=1;b:=a}"
let corpsI2 = "{a:=1;c:=a}"
let m_If = condI^corpsI1^corpsI2
let test_executer = executer m_If
let _ = print_string "END TEST \n \n \n \n \n \n \n \n\n \n"


let _ = print_string "TEST avec exemple \n"
let assigns = "a:=1;b:=1;c:=1;"
let condI = "if(c)"
let corpsI1 = "{c:=0;a:=b}"
let corpsI2 = "{b:=0;c:=a}"
let m_If = condI^corpsI1^corpsI2
let condW = "while(a)"
let corpsW = "{"^m_If^"}"
let m_While = condW^corpsW
let fonct = assigns^m_While
let l = P.list_of_string fonct
let _ = printList l; print_string "\n"
let test_executer = executer fonct
let _ = print_string "END TEST \n \n"



