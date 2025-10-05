open Ecs
open Component_defs
open System_defs

type tag += Enemy of enemy

let enemy (name, hp, x, y, txt, width, height) =
  let e = new enemy name in
  e#texture#set txt;
  e#tag#set (Enemy e);
  e#health#set hp;
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width; height};
  e#velocity#set Vector.{x=Cst.default_enemy_speed; y=0.};
  e#resolve#set (fun _ t ->
    match t#tag#get with
      | Box.Ceiling(b) ->
        e#velocity#set Vector.{x=e#velocity#get.x; y=0.};
        let sp, sr = Rect.mdiff e#position#get e#box#get b#position#get b#box#get in
        let pv = Rect.penetration_vector sp sr in
        e#position#set Vector.{x=e#position#get.x; y=e#position#get.y-.pv.y};
      | Box.Floor(b) ->
        e#velocity#set Vector.{x=e#velocity#get.x; y=0.};
        let sp, sr = Rect.mdiff e#position#get e#box#get b#position#get b#box#get in
        let pv = Rect.penetration_vector sp sr in
        e#position#set Vector.{x=e#position#get.x; y=e#position#get.y-.pv.y};
        e#falling#set false
      | Box.Wall(b) | Box.Warp(b, _, _, _) ->
        (*L'enemy fait demi-tour s'il rencontre un mur/une warpzone*)
        e#velocity#set Vector.{x=(-.e#velocity#get.x); y=e#velocity#get.y};
        let sp, sr = Rect.mdiff e#position#get e#box#get b#position#get b#box#get in
        let pv = Rect.penetration_vector sp sr in
        e#position#set Vector.{x=e#position#get.x-.pv.x; y=e#position#get.y}
      | Box.Platform(b) ->
        let sp, sr = Rect.mdiff e#position#get e#box#get b#position#get b#box#get in
        let pv = Rect.penetration_vector sp sr in
        let pvx, pvy = pv.x, pv.y in
        if pvx = 0. && pvy >= 0. then
          begin
          e#velocity#set Vector.{x=e#velocity#get.x; y=0.};
          e#position#set Vector.{x=e#position#get.x; y=e#position#get.y-.pv.y};
          e#falling#set false
          end
        else
          (e#position#set Vector.{x=e#position#get.x-.pv.x; y=e#position#get.y-.pv.y};
          e#velocity#set Vector.{x=(-.e#velocity#get.x); y=e#velocity#get.y})
      | Player.Player -> (*Si possible, attaquer*) ()
      | _ -> ()); (*Des cas s'ajouteront avec le temps*)
  e

let stop e = e#velocity#set Vector.zero

let move e v = e#velocity#set v

let load enemies = List.iter (fun e ->
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  Move_system.(register (e :> t))) enemies

let unload enemies = List.iter (fun e ->
  Draw_system.(unregister (e :> t));
  Collision_system.(unregister (e :> t));
  Move_system.(unregister (e :> t))) enemies

let test_enemy x y = enemy ("test", 1, x, y, Texture.red, 100, 100)