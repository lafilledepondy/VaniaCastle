open Ecs
open Component_defs
open System_defs

let load a =
  let boxes = a#walls#get in
  let enemies = a#enemies#get in
  let elts = a#elements#get in
  (*Chargement des boîtes*)
  List.iter (fun w ->
    Collision_system.(register (w :> t));
    Draw_system.(register (w :> t));
    match w#tag#get with
    | Block _ -> Move_system.(register (w :> t))
    | _ -> ()
  ) boxes;
  (*Chargement des items*)
  List.iter (fun e ->
    Collision_system.(register (e :> t));
    Draw_system.(register (e :> t));
    Time_system.(register (e :> t))
  ) elts;
  (*Chargment des ennemis*)
  List.iter (fun e ->
    Collision_system.(register (e :> t));
    Draw_system.(register (e :> t));
    Move_system.(register (e :> t));
    Fight_system.(register (e :> t));
    Death_system.(register (e :> t));
    Gravity_system.(register (e :> t));
    e#health#set e#max_health#get; (*On reset leur vie pour éviter qu'ils meurent instantanément si leur points de vie sont à 0*)
    Animation_system.(register (e :> t))
  ) enemies

let load' a _ = load a



let unload a =
  let boxes = a#walls#get in
  let enemies = a#enemies#get in
  let elts = a#elements#get in
  let g = Global.get () in
  (*Suppression des projectiles*)
  List.iter (fun p -> p#delete#get ()) g.projectiles;
  (*Déchargement des boîtes*)
  List.iter (fun w ->
    Collision_system.(unregister (w :> t));
    Draw_system.(unregister (w :> t));
    match w#tag#get with
    | Block _ -> Move_system.(unregister (w :> t))
    | _ -> ()
  ) boxes;
  (*Déchargement des items*)
  List.iter (fun e ->
    Collision_system.(unregister (e :> t));
    Draw_system.(unregister (e :> t));
    Time_system.(unregister (e :> t))
  ) elts;
  (*Déchargement des ennemis*)
  List.iter (fun e ->
    Collision_system.(unregister (e :> t));
    Draw_system.(unregister (e :> t));
    Move_system.(unregister (e :> t));
    Fight_system.(unregister (e :> t));
    Death_system.(unregister (e :> t));
    Gravity_system.(unregister (e :> t));
    Animation_system.(unregister (e :> t));
  ) enemies

let unload' a _ = unload a

let reload a =
  unload a;
  load a

let area (x_orr, y_orr, width, height, elts, walls, enemies) =
  let e = new area () in
  e#tag#set Area;
  e#box#set Rect.{width; height};
  e#position#set Vector.{x = float x_orr; y = float y_orr};
  e#elements#set elts;
  e#walls#set walls;
  e#enemies#set enemies;
  e#load#set (load' e);
  e#unload#set (unload' e);
  e

let void () =
  area (0, 0, 0, 0, [], [], [])