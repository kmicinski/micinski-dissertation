(* 
   Time varying semantics for data
*)
type ch = string

type expr = 
  | Nat of int
  | Loc of int
  | Unit
  | Lambda of string * expr
  | Primfunc of string * expr list
  | Var of string
  | App of expr * expr
  | Ref of expr
  | Asn of expr * expr
  | Deref of expr
      (* *)
  | Install of ch * expr
  | Send of ch * expr
  | Declassify of expr

(* Machine state *)
type msigma = 
    {
      mqueue : (ch * expr) list;
      heap : (int * expr) list;
      hmap : (ch * expr) list;
      smap : (ch * int) -> expr list;
      i : int
    }

(* Generate a fresh location in the heap l *)
let fresh_loc l = (List.fold_left max 0 (List.map fst l)) + 1

(* Lookup a value from a heap *)
let rec lookup heap l =
  match heap with 
    | [] -> failwith "Not in map.."
    | (l',v)::tl -> if (l' = l) then v else lookup tl l

let rec subst binder replacement = function
  | Lambda (s,e) -> if (s = binder) then e else (subst binder replacement e)
(*  | Primfunc of string * expr list*)
  | Var s -> if (s = binder) then replacement else (Var s)
  | App (e1,e2) -> App (subst binder replacement e1, subst binder replacement e2)
  | Ref e -> Deref (subst binder replacement e)
  | Asn (e1,e2) -> Asn (subst binder replacement e1, subst binder replacement e2)
  | Deref e -> Deref (subst binder replacement e)
  | Install (ch, e) -> Install (ch, subst binder replacement e)
  | Send (ch, e) -> Install (ch, subst binder replacement e)
  | Declassify e -> Declassify (subst binder replacement e)
    
(* Step function for evaluator
   Computation of judgement e, Sigma1 \Downarrow v, Sigma2
 *)
let rec eval_step (e, msigma) : expr * msigma =
  match e with
    | Nat n -> (e, msigma)
    | App (e1, e2) ->
      let (Lambda (x, e3), msigma2) = eval_step (e1, msigma) in
      let (v1, msigma3) = eval_step (e2, msigma2) in
      eval_step ((subst x v1 e3), msigma3)
    | Ref e ->
      let v,msigma2 = eval_step (e, msigma) in
      let l = fresh_loc msigma2.heap in
      Loc l , { msigma2 with heap = (l,v)::msigma2.heap } 
    | Asn (e1,e2) ->
      let (Loc l, msigma2) = eval_step (e1, msigma) in
      let (v, msigma3) = eval_step (e2, msigma2) in
      v , { msigma3 with heap = (l,v)::msigma3.heap }
    | Deref e ->
      let (Loc l, msigma2) = eval_step (e, msigma) in
      (lookup msigma2.heap l), msigma2
    | Install (ch, e) -> 
      let (Lambda (x, e), msigma2) = eval_step (e, msigma) in
      let hmap' = (ch, Lambda (x, e))::msigma2.hmap in
      Unit , { msigma2 with hmap = hmap' }
    | Send (ch, e) ->
      let (v, msigma2) = eval_step (e, msigma) in
      Unit , { msigma2 with mqueue = msigma2.mqueue @ [(ch,v)] }
    | Declassify e -> e , msigma

(* Generate the set of possible next states for a machine
   configuration *)

let step_state msigma =
  let msg = match msigma.mqueue with
    | (ch, value)::tl ->
      let Lambda (x,e) = lookup (msigma.hmap) ch in
      let e' = subst x value e in
      let result,msigma' = eval_step (e', {msigma with mqueue = tl}) in
      [{msigma' with i = msigma.i+1}]
    | [] -> []
  in
  msg

(* Given a start handler, get a new configuration *)
let inject_initial_sigma expr secrets =
    {
      mqueue = [("start",Unit)];
      heap = [];
      hmap = ["start",expr];
      smap = secrets;
      i = 0
    }
