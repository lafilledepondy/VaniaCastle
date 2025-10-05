open Ecs
open Component_defs
open System_defs

type tag += Area

let area (x_orr, y_orr, width, height, elts, tex, walls, enemies) =
  let e = new area () in
  e#texture#set tex;
  e#tag#set Area;
  e#box#set Rect.{width; height};
  e#position#set Vector.{x = float x_orr; y = float y_orr};
  e#elements#set elts;
  e#walls#set walls;
  e#enemies#set enemies;
  e

(*Quand le perso est environ au milieu de l'écran, on bouge strictement tout dans la direction opposée, d'où l'existence de cette fonction*)
(*Inutile ?*)
let move_area a v =
  a#position#set Vector.{x=a#position#get.x+.v.x; y=a#position#get.y+.v.y};
  List.iter (fun b -> Box.move_box b v) a#walls#get

let void () =
  area (0, 0, 0, 0, [], Texture.transparent, [], [])

let load a =
  Draw_system.(register (a :> t));
  let boxes = a#walls#get in
  let enemies = a#enemies#get in
  let elts = a#elements#get in
  List.iter (fun w -> Collision_system.(register (w :> t)); Draw_system.(register (w :> t))) boxes;
  List.iter (fun e -> Collision_system.(register (e :> t)); Draw_system.(register (e :> t)); Time_system.(register (e :> t))) elts;
  List.iter (fun e -> Collision_system.(register (e :> t)); Draw_system.(register (e :> t)); Move_system.(register (e :> t))) enemies

let unload a =
  Draw_system.(unregister (a :> t));
  let boxes = a#walls#get in
  let enemies = a#enemies#get in
  let elts = a#elements#get in
  List.iter (fun w -> Collision_system.(unregister (w :> t)); Draw_system.(unregister (w :> t))) boxes;
  List.iter (fun e -> Collision_system.(unregister (e :> t)); Draw_system.(unregister (e :> t)); Time_system.(unregister (e :> t))) elts;
  List.iter (fun e -> Collision_system.(unregister (e :> t)); Draw_system.(unregister (e :> t)); Move_system.(unregister (e :> t))) enemies

let pause a =
  let boxes = a#walls#get in
  let enemies = a#enemies#get in
  let elts = a#elements#get in
  List.iter (fun w -> Collision_system.(unregister (w :> t))) boxes;
  List.iter (fun e -> Collision_system.(unregister (e :> t)); Time_system.(unregister (e :> t))) elts;
  List.iter (fun e -> Collision_system.(unregister (e :> t)); Move_system.(unregister (e :> t))) enemies

let unpause a =
  let boxes = a#walls#get in
  let enemies = a#enemies#get in
  let elts = a#elements#get in
  List.iter (fun w -> Collision_system.(register (w :> t))) boxes;
  List.iter (fun e -> Collision_system.(register (e :> t)); Time_system.(register (e :> t))) elts;
  List.iter (fun e -> Collision_system.(register (e :> t)); Move_system.(register (e :> t))) enemies