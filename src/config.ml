open Parseur
open State

module P = Parseur
module S = State

module Config =
  struct
    type config = |Inter of (P.instr, P.state)
                  |Final of (P.state)


    let faire_un_pas (instr : P.instr) (state : P.state) : config =
      
  end
