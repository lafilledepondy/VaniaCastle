open Ecs
open Component_defs
open System_defs



let print_inventory player =
  let inv = player#inventory#get in
  Hashtbl.iter (fun n (q, _) -> Gfx.debug "nom : %s; qté : %d\n%!" n q) inv



let fireball p =
  let cool = p#cooldown#get in
  if fst(cool) = snd(cool) && p#mana#get >= 10 then
    (let pPos = p#position#get in
    let pBox = p#box#get in
    let y = pPos.Vector.y +. ((float pBox.Rect.height)/.2.) -. 25. in
    let x, sx =
      if p#left#get then 
        pPos.Vector.x -. 50., -7.
      else
        pPos.Vector.x +. (float pBox.Rect.width), 7.
    in
    let w, h = 50, 50 in
    let atq = int_of_float (1.3 *. (float p#atq#get)) in
    let time = 10. in
    let _ = Projectile.projectile (int_of_float x, int_of_float y, !Cst.fireBallTex, w, h, atq, time, sx, 0., Projectile.Magic, false) in
    p#cooldown#set (fst(cool)-1, snd(cool));
    p#mana#set (p#mana#get - 10))

let attack p =
  let cool = p#cooldown#get in
  if fst(cool) = snd(cool) then
    (let pPos = p#position#get in
    let eBox = p#box#get in
    let dmg = p#dmg_box#get in
    let w = dmg.Rect.width in
    let h = dmg.Rect.height in
    let x =
      if p#left#get then
        int_of_float (pPos.Vector.x -. (float w))
      else
        int_of_float (pPos.x+. (float eBox.Rect.width))
    in
    let atq = p#atq#get in
    let time = 0.2 in
    let y=int_of_float pPos.Vector.y in
    let _ = Projectile.projectile (x, y, Texture.transparent, w, h, atq, time, 0., 0., Projectile.Attack, false) in
    p#cooldown#set (fst(cool)-1, snd(cool));
    p#current_animation#set Atk;
    let (y, maxX) = Hashtbl.find p#frame_set#get Atk in
    p#animation_index#set (0, y, maxX))



let player (name, x, y, txt, width, height) =
  let e = new player name in
  e#priority#set 4;
  e#atq#set 10;
  e#health#set 100;
  e#mana#set 100;
  e#mass#set 1.;
  e#texture#set txt;
  e#tag#set Player;
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width; height};
  e#velocity#set Vector.zero;
  e#cooldown#set (30, 30);
  e#dmg_box#set Rect.{width=60; height};
  e

let createPlayer () =
  let p = player  Cst.("player1", 70, 300, Texture.blue, 60, 190) in
  Hashtbl.add (p#frame_set#get) Idle (0, 0);
  Hashtbl.add (p#frame_set#get) Walk (1, 9);
  Hashtbl.add (p#frame_set#get) Atk (2, 7);
  Hashtbl.add (p#frame_set#get) Jump (3, 0);
  Hashtbl.add (p#frame_set#get) Fall (4, 0);
  p#file_width#set 2660;
  p#visual_box#set Rect.{width=133; height=191};
  p#visual_offset#set Vector.{x= -.19.; y=0.};
  p#has_offset#set true;
  p



(* ##### UTILITAIRES ##### *)
let player1 () = 
  let Global.{player; _ } = Global.get () in
  player

let horizontally_stop_players () = 
  let Global.{player; _ } = Global.get () in
  player#velocity#set Vector.{x=0.; y= player#velocity#get.y}

let walk player x =
  player#velocity#set Vector.{x; y=player#velocity#get.y}

let jump player =
  if player#coyote_time#get > 0 then
    (player#velocity#set Vector.{x=player#velocity#get.x; y=Cst.jump_power};
    player#coyote_time#set 0)

let decrement_coyote player =
  let c = player#coyote_time#get in
  if c > 0 then
    player#coyote_time#set (c-1)

let decrement_invincibility player =
  let i = player#invincibility#get in
  if i > 0 then
    player#invincibility#set (i-1)



(* ##### CHARGEMENT ##### *)
let unload player = 
  Collision_system.(unregister (player :> t));
  Draw_system.(unregister (player :> t));
  Move_system.(unregister (player :> t));
  Animation_system.(unregister (player :> t));
  Gravity_system.(unregister (player :> t))

let load player = 
  Collision_system.(register (player :> t));
  Draw_system.(register (player :> t));
  Move_system.(register (player :> t));
  Animation_system.(register (player :> t));
  Gravity_system.(register (player :> t))