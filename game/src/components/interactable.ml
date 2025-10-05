open Ecs
open Component_defs
open System_defs



type interType = 
    | OtherItem
    | CollectableItem


(*Supprime l'item e*)    
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

(*fonction () -> () qui supprime l'item e*)
let del e _ = remove_interactable e



let load i =
  Draw_system.(register (i :> t));
  Collision_system.(register (i :> t));
  Time_system.(register (i :> t))



(*Ajoute e à l'inventaire du player*)
let ajoute_inventaire e =
  let inventory = ((Global.get ()).player)#inventory#get in
  let name = e#name in
  let f = e#interaction#get in
  let qte = match Hashtbl.find_opt inventory name with None -> 0 | Some (q, _) -> q in
  Hashtbl.replace inventory name (qte+1, f);
  remove_interactable e



let interactable (name, x, y, txt, width, height, action, time, inter) =
  let e = new interactable name in
  e#mass#set 1.;
  e#texture#set txt;
  e#priority#set 3;
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width; height};
  e#file_width#set width;
  e#interaction#set action;
  e#duration#set time;
  e#birth#set (Sys.time ());
  e#delete#set (del e);
  e#tag#set (
    match inter with
    | OtherItem -> OtherItem(e)
    | CollectableItem -> CollectableItem(e)
  );
  e#unload#set (fun _ -> remove_interactable e);
  e#add_inventory#set (fun _ -> ajoute_inventaire e);
  e



(* ##### CALICE DE SOIN ##### *)
(* Soigne le player de 10 points de vie *)
let heal _ =
  let p = (Global.get ()).player in
  p#health#set (p#health#get+10)

let healingChalice x y =
  interactable ("HealingChalice", x, y, !Cst.chalice, 30, 30, heal, 10., OtherItem)

(* ##### ORBE DE MANA ##### *)
(* Rend au player 10 points de mana *)
let refill _ =
  let p = (Global.get ()).player in
  p#mana#set (p#mana#get+10)

let manaVial x y =
  interactable ("ManaVial", x, y, !Cst.manaVial, 30, 30, refill, 10., OtherItem)

(* ##### ANTI-CROIX ##### *)
(* Ajoute 2 points d'attaque au player *)
let atk_bonus _ =
  let p = (Global.get ()).player in
  p#atq#set (p#atq#get+2)

let antiCross x y =
  interactable ("antiCross", x, y, !Cst.antiCross, 30, 30, atk_bonus, 10., OtherItem)