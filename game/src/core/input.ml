open System_defs

let key_table = Hashtbl.create 16
let has_key s = Hashtbl.mem key_table s
let set_key s= Hashtbl.replace key_table s ()
let unset_key s = Hashtbl.remove key_table s

let action_table = Hashtbl.create 16
let register key action = Hashtbl.replace action_table key action

let forbidden = Hashtbl.create 16
let ban s = Hashtbl.replace forbidden s ()
let unban s = Hashtbl.remove forbidden s
let banned s = Hashtbl.mem forbidden s

let handle_input () =
  let () =
    match Gfx.poll_event () with
      KeyDown s -> set_key s
    | KeyUp s -> unset_key s; unban s
    | Quit -> exit 0
    | _ -> ()
  in
  Hashtbl.iter (fun key action ->
      if (has_key key) && not(banned key) then action ()) action_table

let () =
  register "r" (fun () -> (*Rechargement de la zone courante*)
    let g = Global.get () in
    if not(g.waiting) && g.started then
      (Area.reload g.area; Gfx.debug "Reloaded\n%!")
    );

  register "z" (fun () -> (*Saut*)
    let g = Global.get () in
    if not(g.waiting) && g.started then
      Player.(
        let p = player1() in
        if p#invincibility#get < 25 then
          jump p
    ));

  register "d" (fun () -> (*Marcher vers la droite*)
    let g = Global.get () in
    if not(g.waiting) && g.started then
      Player.(
        let p = player1() in
        if p#invincibility#get < 25 then
          (walk p Cst.right;
          p#left#set false
    )));

  register "q" (fun () -> (*Marcher vers la gauche*)
    let g = Global.get () in
    if not(g.waiting) && g.started then
      Player.(
        let p = player1() in
        if p#invincibility#get < 25 then
          (walk p Cst.left;
          p#left#set true
    )));

  register "p" (fun () ->
    let p = (Global.get ()).player in (*Affichage de debug*)
    Gfx.debug "coyote : %d\n fall : %b\n fall speed : %f\n pos : (%f, %f)\n\n%!" p#coyote_time#get p#falling#get p#velocity#get.Vector.y p#position#get.Vector.x p#position#get.Vector.y);

  register "s" (fun () -> (*Pause*)
      let global = Global.get () in
      if global.started then
      (global.waiting <- not(global.waiting);
      ban "s")
    );

  register "shift" (fun () -> ()); (*Inutilisé mais réservé pour l'inventaire*)

  register " " (fun () -> let p = (Global.get ()).player in Player.attack p); (*Attaque de mêlée*)

  register "e" (fun () -> let p = (Global.get ()).player in Player.fireball p); (*Boule de feu*)

  register "Enter" (fun () -> (*Sur l'écran titre, démarre le jeu*)
    let g = Global.get() in
    if g.started then ()
    else
      (
        g.started <- true;
        Area.load g.area;
        Player.load g.player;
        Draw_system.(register (g.healthBar :> t));
        Draw_system.(register (g.manaBar :> t));
        Draw_system.(register (g.enemyHealthBar :> t));
        match g.screen with
        | None -> failwith "unreachable"
        | Some s ->
          (Draw_system.(unregister (s :> t));
          g.screen <- None)
      ));