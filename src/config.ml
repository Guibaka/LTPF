open Parseur
open State

module P = Parseur
module S = State

module Config =
  struct
    type config = | Inter of ((P.instr)* (S.state))
                  | Final of (S.state)


    
    (* Création d'un fonction eval pour les booléens *)
    let eval (exp : P.exp) (s: S.state) : (bool) =
      match exp with
      |Var(a) -> (match (S.read a s) with
                  |0 -> false
                  |_ -> true
                 )
      |Cst(a) -> if a=0 then false else true
    
    let rec faire_un_pas (instr : P.instr) (state : S.state) : config =
      match instr with
      |P.Skip -> Final(state)
      |P.Assign(v1, v2) -> Final(state)
      |P.Seq(i1, i2) -> (match (faire_un_pas i1 state) with
                         |Inter(i, s) -> Inter(P.Seq(i1,i2), s)
                         |Final(s) -> Final(s)
                        )
      (* ici il faudra évaluer e, si c'est vrai ou faux on fait l'instruction i/i1/i2 *)
      |P.If(e, i1, i2) -> if (eval e state) then Inter(i1, state) else Inter(i2, state)
      |P.While(e, i) ->  Inter(P.If(e, P.Seq(i, P.While(e,i)), P.Skip),  state )

    let printConfig (c : config) =
      match c with
      |Inter(i, s) -> (print_string "Inter ") ; (P.printInstr i) ; (S.printState s)
      |Final(s) -> (print_string "Final "); (S.printState s)
  end

