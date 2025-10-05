open Ecs
open Component_defs
open System_defs

type tag += 
| OtherItem of interactable
| CollectableItem of interactable

type interType = 
    | OtherItem
    | CollectableItem


(*On utilise cette fonction dans `interactable`.*)    
let remove_interactable e =
  Draw_system.(unregister (e :> t));
  Collision_system.(unregister (e :> t));
  Time_system.(unregister (e :> t));
  let a = (Global.get ()).area in
  let elts = a#elements#get in
  let rec remove_elt l =
    match l with
    | [] -> []
    | elt::ll ->
      if e = elt then
        ll
      else
        elt::(remove_elt ll)
  in
  a#elements#set (remove_elt elts)

let del e u = remove_interactable e

let interactable (name, x, y, txt, width, height, action, time, inter) =
  let e = new interactable name in
  e#texture#set txt;
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width; height};
  e#interaction#set action;
  e#duration#set time;
  e#birth#set (Sys.time ());
  e#delete#set (del e);
  e#tag#set (
    match inter with
    | OtherItem -> OtherItem(e)
    | CollectableItem -> CollectableItem(e)
  );
  e 

let load i =
  Draw_system.(register (i :> t));
  Collision_system.(register (i :> t));
  Time_system.(register (i :> t))

let ajoute_inventaire e =
  let inventory = ((Global.get ()).player)#inventory#get in
  let name = e#name in
  let f = e#interaction#get in
  let qte = match Hashtbl.find_opt inventory name with None -> 0 | Some (q, _) -> q in
  Hashtbl.replace inventory name (qte+1, f);
  remove_interactable e