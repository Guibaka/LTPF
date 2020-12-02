module Parseur :
sig
  type v
  type c
  type exp
  type instr

  type 't analist
  type ('r, 't) ranalist
  type ('x,'t) st = 't list -> 'x

  val list_of_string : string -> char list
  exception Echec
  val (+>) :  ('t analist) -> ('x, 't) st -> ('x, 't) st
  val (++>) :  ('r, 't) ranalist -> ('r -> ('x, 't) st) -> ('x, 't) st
  val return : 'r -> ('r, 't) ranalist
  val terminal : 't -> 't analist
  
  val p_E : (exp, char) ranalist
  val p_S : (instr, char) ranalist
  val p_L : (instr, char) ranalist
  val p_I : (instr, char) ranalist
  
end
