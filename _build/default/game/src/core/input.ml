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

let () = (*À modifier*)
  register "z" (fun () -> if not(Global.get ()).waiting then Player.(let p = player1() in jump p));
  register "d" (fun () -> if not(Global.get ()).waiting then Player.(walk (player1()) Cst.right));
  register "q" (fun () -> if not(Global.get ()).waiting then Player.(walk (player1()) Cst.left));
  register "p" (fun () -> let p =
    (Global.get ()).player in
    let a = (Global.get ()).area in
    let pp, pv = p#position#get, p#velocity#get in
    let ww = Cst.window_width in
    let wh = Cst.window_height in
    let a_p = a#position#get in
    let a_box = a#box#get in
    let condition_x_right = pp.Vector.x > float (ww/2) && pv.Vector.x > 0. && (a_p.Vector.x > (-.float (a_box.width - 800))) in
    let condition_x_left = pp.Vector.x < float (ww/2) && pv.Vector.x < 0. && (a_p.Vector.x < 0.) in
    let condition_y_down = pp.Vector.y > float (wh/2) && pv.Vector.y > 0. && (a_p.Vector.y > (-.float (a_box.height - 600))) in
    let condition_y_up = pp.Vector.y < float (wh/2) && pv.Vector.y < 0. && (a_p.Vector.y < 0.) in
    Gfx.debug "vx  : %f\nvy  : %f\npx  : %f\npy  : %f\ncxr : %b\ncxl : %b\ncyd : %b\ncyu : %b\n\n%!"
                                        (pv.x)
                                        (pv.y)
                                        (pp.x)
                                        (pp.y)
                                        condition_x_right
                                        condition_x_left
                                        condition_y_down
                                        condition_y_up);
  register "g" Ball.restart;
  register "s" (fun () ->
      let global = Global.get () in
      global.waiting <- not(global.waiting);
      if global.waiting then
        begin
        Area.pause global.area;
        Player.pause global.player
        end
      else
        begin
        Area.unpause global.area;
        Player.unpause global.player
        end;
      ban "s"
    );
  register "shift" (fun () -> ()) (*Inventaire*)
