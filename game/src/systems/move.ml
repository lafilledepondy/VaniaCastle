open Ecs
open Component_defs

type t = movable

let init _ = ()

let update _ el =
  let default_movement e =
    let p = e#position#get in
    let v = e#velocity#get in
    e#position#set (Vector.add p v)
  in

  (*La fonction qui bouge toute la carte avec le player et décide de l'animation courante du player*)
  let player_movement _ =
    let e = (Global.get ()).player in
    let p = e#position#get in
    let v = e#velocity#get in
    (if e#current_animation#get = Atk then
      ()
    else if v = Vector.zero then
      e#current_animation#set Idle
    else if v.Vector.y > 1.001 then (*chute et saut on la priorité sur déplacement*)
      e#current_animation#set Fall
    else if v.Vector.y < 0. then
      e#current_animation#set Jump
    else if v.Vector.x <> 0. then
      e#current_animation#set Walk);
    (* Permet d'éviter d'être satéllisé quand on touche un plafond *)
    if v.Vector.y < Cst.jump_power then e#velocity#set Vector.{x=v.Vector.x; y=Cst.jump_power};
    let v = e#velocity#get in
    let a = (Global.get ()).area in
    let a_box = a#box#get in
    let a_p = a#position#get in
    let ww = Cst.window_width in
    let wh = Cst.window_height in
    let condition_x_right = p.Vector.x > float (ww/2) && v.Vector.x > 0. && (a_p.Vector.x > (-.float (a_box.width - 800))) in
    let condition_x_left = p.Vector.x < float (ww/2) && v.Vector.x < 0. && (a_p.Vector.x < 0.) in
    let map_movementX, player_movementX = (
      if condition_x_right || condition_x_left then
        (-.v.Vector.x, 0.)
      else
        (0., v.Vector.x)
    )
    in
    let condition_y_down = p.Vector.y > float (wh/2) && v.Vector.y > 0. && (a_p.Vector.y > (-.float (a_box.height - 600))) in
    let condition_y_up = p.Vector.y < float (wh/2) && v.Vector.y < 0. && (a_p.Vector.y < 0.) in
    let map_movementY, player_movementY = (
      if condition_y_down || condition_y_up then
        (-.v.Vector.y, 0.)
      else
        (0., v.Vector.y)
    )
    in
    let player_movement = Vector.{x=player_movementX; y=player_movementY} in

    e#position#set (Vector.add p player_movement);
    a#position#set Vector.{x=a#position#get.x+.map_movementX; y=a#position#get.y+.map_movementY};
    List.iter (fun b -> b#position#set Vector.{x=b#position#get.x+.map_movementX; y=b#position#get.y+.map_movementY}) a#walls#get;
    (*On bouge les éléments avec l'ensemble de la carte*)
    List.iter (fun i -> i#position#set Vector.{x=i#position#get.x+.map_movementX; y=i#position#get.y+.map_movementY}) a#elements#get;
    (*Idem pour les enemmis*)
    List.iter (fun i -> i#position#set Vector.{x=i#position#get.x+.map_movementX; y=i#position#get.y+.map_movementY}) a#enemies#get;
    List.iter (fun i -> i#position#set Vector.{x=i#position#get.x+.map_movementX; y=i#position#get.y+.map_movementY}) (Global.get ()).projectiles;
    if e#falling#get && v.Vector.y < Cst.max_fall_speed then (e#velocity#set Vector.{x=v.x; y=v.y +. Cst.gravity});
    e#falling#set true
  in
  Seq.iter (fun e ->
    (match e#tag#get with
    | Player -> player_movement ()
    | Enemy(e, _) ->
      (*Si un ennemy n'est pas en train d'attaquer, on fait son pattern*)
      if (fst(e#atq_prep#get) = snd(e#atq_prep#get)) then e#pattern#get ();
      default_movement e
    | _ -> default_movement e))
    el