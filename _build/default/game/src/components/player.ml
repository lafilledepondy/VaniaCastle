open Ecs
open Component_defs
open System_defs

type tag += Player

let print_inventory player =
  let inv = player#inventory#get in
  Hashtbl.iter (fun n (q, _) -> Gfx.debug "nom : %s; qté : %d\n%!" n q) inv

let player (name, x, y, txt, width, height) =
  let e = new player name in
  e#texture#set txt;
  e#tag#set Player;
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width; height};
  e#velocity#set Vector.zero;
  e#is_player#set true;
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
        e#coyote_time#set Cst.coyote;
        e#falling#set false
      | Box.Wall(b) ->
        e#velocity#set Vector.{x=0.; y=e#velocity#get.y};
        let sp, sr = Rect.mdiff e#position#get e#box#get b#position#get b#box#get in
        let pv = Rect.penetration_vector sp sr in
        e#position#set Vector.{x=e#position#get.x-.pv.x; y=e#position#get.y}
      | Box.Platform(b) ->
        (*e#velocity#set Vector.{x=0.; y=e#velocity#get.y};*)
        let sp, sr = Rect.mdiff e#position#get e#box#get b#position#get b#box#get in
        let pv = Rect.penetration_vector sp sr in
        let pvx, pvy = pv.x, pv.y in
        if pvx = 0. && pvy >= 0. then
          begin
          e#velocity#set Vector.{x=e#velocity#get.x; y=0.};
          e#position#set Vector.{x=e#position#get.x; y=e#position#get.y-.pv.y};
          e#coyote_time#set Cst.coyote;
          e#falling#set false
          end
        else
          (Gfx.debug "Bonk\n%!";
          e#position#set Vector.{x=e#position#get.x-.pv.x; y=e#position#get.y-.pv.y})
      | Box.Warp(b, dest, xOff, yOff) ->
        let g = Global.get () in
        let orr = g.area in
        Area.unload orr;
        Area.load dest;
        g.area <- dest;
        e#position#set Vector.{x=float(xOff (int_of_float e#position#get.x)); y=float(yOff (int_of_float e#position#get.y))};
        (*Quand le personnage passe sur l'objet, on effectue la fonction d'intéreaction*)
      | Interactable.OtherItem (i) ->
        i#interaction#get ();
        Gfx.debug "Removing interactable --> player touched\n%!";
        Interactable.remove_interactable i
      | Interactable.CollectableItem (i) -> 
        Gfx.debug "Adding interactable to inventory --> player touched\n%!";
        Interactable.ajoute_inventaire i;
        print_inventory e
      (*Le comportement face à un enemi est géré dans enemy.ml; ça changera quand on aura des mly*)
      | _ -> ()); (*Des cas s'ajouteront avec le temps*)        
    Draw_system.(register (e :> t));
    Collision_system.(register (e :> t));
    Move_system.(register(e :> t));
    e

let players () =  (*Test Values*)
  player  Cst.("player1", Cst.paddle1_x, Cst.paddle1_y, paddle_color, paddle_width, paddle_height)


let player1 () = 
  let Global.{player; _ } = Global.get () in
  player

let completly_stop_players () = 
  let Global.{player; _ } = Global.get () in
  player#velocity#set Vector.zero

let horizontally_stop_players () = 
  let Global.{player; _ } = Global.get () in
  player#velocity#set Vector.{x=0.; y= player#velocity#get.y}

let move_player player v =
  player#velocity#set v

let replace_player player v =
  let pos = player#position#get in
  player#position#set Vector.{x=pos.x+.v.x; y=pos.y+.v.y}

let walk player x =
  move_player player Vector.{x; y=player#velocity#get.y}

let jump player =
  if player#coyote_time#get > 0 then
    (Gfx.debug "Boing\n%!";
    player#velocity#set Vector.{x=player#velocity#get.x; y=Cst.jump_power};
    player#coyote_time#set 0)

let decrement_coyote player =
  let c = player#coyote_time#get in
  if c > 0 then
    player#coyote_time#set (c-1)
  
let pause player =
  Collision_system.(unregister (player :> t));
  Move_system.(unregister (player :> t))

let unpause player =
  Collision_system.(register (player :> t));
  Move_system.(register (player :> t))