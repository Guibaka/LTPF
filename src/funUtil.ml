open Parseur

module P = Parseur


module State =

  struct
    (* typedef de ce que c'est qu'un état *)
    (* Un état c'est: une variable (char), une valeur (int) et un état suivant (state)   *)
    type state = | State of (char * int * state)
                 | End

    (* Lire la valeur d'une variable *)
    (* On peut raise une exception lorsqu'on ne trouve pas ce qu'on cherche*)
    exception NotFound
    

    (* Initialisation *)
    (* Ici on initialise toutes les variables à 0 récursivement:
       s.value = 0 et on fait pareil pour les prochains jusqu'à End *)
    let rec init (s: state) : (state)  =
      match s with
      |End -> s (* ici on fait rien *)
      |State(var, value, next) -> State(var, 0, (init(next))) (* appliquer init(s)
                                                                 à tous les next         *)

   
    (* On veut la var entrée en paramètre soit égale à la var dans le state dans 
       lequel on se trouve, si c'est le cas on renvoit value. Pour cela on procède par
       récursion pour parcourir les états (logique)                                      *)
    let rec read (var: char) (s: state) : (int) =
      match s with
      |End -> raise NotFound (* Si on arrive ici c'est qu'on l'a pas trouvé *)
      |State(statevar, value, next) -> if (var = statevar) then value 
                                       else (read var next) 

    (* Même principe qu'avant sauf qu'on donne la variable qu'on souhaite changer ET
       la nouvelle valeur                                                                *)
    let rec change (var: char) (value: int) (s: state) : (state) =
      match s with
      |End -> raise NotFound
      |State(statevar, statevalue, next) ->  if (var = statevar) then State(statevar, value, next)
                                             else State(statevar, statevalue, (change var value next))

    let charToExp (var: char) : (P.exp) =
      match var with
      |'a' -> P.Var(A)
      |'b' -> P.Var(B)
      |'c' -> P.Var(C)
      |'d' -> P.Var(D)
      |_ -> raise NotFound
     

    let expToChar (var: P.exp) : (char) =
      match var with
      |P.Var(A) -> 'a'
      |P.Var(B) -> 'b'
      |P.Var(C) -> 'c'
      |P.Var(D) -> 'd'
      |_ -> raise NotFound
     
    
   (* Executation d'affectation : ca fonctionne peut être ? *)
    let  execAffect (i : P.instr) (s: state) : (state) =
      match i with
      |P.Assign(var, valu) ->
        (match valu with
        |P.Var(a) -> (match a with
                     |A -> (change 'a' (read (expToChar var) s) s)
                     |B -> (change 'b' (read (expToChar var) s) s)
                     |C -> (change 'c' (read (expToChar var) s) s)
                     |D -> (change 'c' (read (expToChar var) s) s))
        |P.Cst(a) -> (match a with
                      |Un -> (change (expToChar var) 1 s)
                      |Zero -> (change (expToChar var) 0 s)
                     )
        )
      |_ -> raise NotFound
    
end
