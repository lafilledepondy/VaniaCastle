open System_defs
open Component_defs
open Ecs

let update dt =
  if not((Global.get ()).waiting) then
    (begin
    Player.horizontally_stop_players ();
    Player.decrement_coyote ((Global.get ()).player)
    end);
  let () = Input.handle_input () in
  Collision_system.update dt;
  Draw_system.update dt;
  Move_system.update dt;
  Time_system.update dt;
  None

let run () =
  (* if elapsed_time () >= Cst.time_limit then
    game_over ()
  else
    update_game () *)
  let window_spec = 
    Format.sprintf "game_canvas:%dx%d:"
      Cst.window_width Cst.window_height
  in
  let window = Gfx.create  window_spec in
  let ctx = Gfx.get_context window in
  let font = Gfx.load_font Cst.font_name "" 128 in
  (*let _boxes = Box.default () in*)
  (*let _boxes = Box.wallsZ1 () in*)
  let player = Player.players () in
  let fileZ1 = Gfx.load_image ctx "resources/images/testArea.png" in
  let fileZ1Mirr = Gfx.load_image ctx "resources/images/testAreaMirror.png" in
  let inventoryMenu = Gfx.load_image ctx "resources/images/betaInventory.png" in
  Gfx.main_loop
    (fun _dt -> Gfx.get_resource_opt inventoryMenu)
    (fun textInventory ->
      Gfx.main_loop
        (fun _dt -> Gfx.get_resource_opt fileZ1)
        (fun texZ1 ->
          Gfx.main_loop 
          (fun _dt -> Gfx.get_resource_opt fileZ1Mirr)
          (fun texZ1Mirr ->
            (*Pour éviter que ce bordel traîne ici, il faudra quelque part des fonctions d'initialisation de **BEAUCOUP** de trucs*)
            
            let b1 = Box.testBoxes () in
            let b2 = Box.testBoxesMirr () in
            let area1 = Area.area (0, 0, 800, 600, [], Image(texZ1), b1, []) in
            let warp1Mirr = Box.createWarp (0, 0, 10, 415, Texture.transparent, (area1, (fun _ -> (800-(11+Cst.paddle_width))), (fun y -> y))) in
            let warp2Mirr = Box.createWarp (790, 0, 10, 543, Texture.transparent, (area1, (fun _ -> 11), (fun y -> y))) in
            let bMirr = warp1Mirr::warp2Mirr::b2 in
            let area1Mirr = Area.area (0, 0, 800, 600, [], Image(texZ1Mirr), bMirr, []) in
            let warp1 = Box.createWarp (0, 0, 10, 543, Texture.transparent, (area1Mirr, (fun _ -> (800-(11+Cst.paddle_width))), (fun y -> y))) in
            let warp2 = Box.createWarp (790, 0, 10, 415, Texture.transparent, (area1Mirr, (fun _ -> 11), (fun y -> y))) in
            let b = warp1::warp2::b1 in
            area1#walls#set b;  

            let tex = Cst.ball_color in
            let inter1 = Interactable.interactable ("test", 100, 200, tex, 50, 50, (fun () -> Gfx.debug "interacting\n%!"), Cst.inter_default_time, Interactable.CollectableItem) in
            
            let enemy1 = Enemy.test_enemy 100 100 in
            let enemies = [enemy1] in
            (* Gfx.debug "Initial interactable time: %f\n%!" (match Cst.inter_default_time with Finite f -> f | Inf -> Float.infinity); *)
            (*La première liste de paramètres, c'est les interactables de la zone. J'y ait mis celui que t'as créé*)
            (* let area1 = Area.area (0, -1200, 7200, 1800, [inter1], Image(texZ1), Box.wallsZ1 (), enemies) in *)
            let global = Global.{ window; ctx; player; waiting = false; area=area1; deb=(Sys.time ())} in 

            Area.load area1;
            Global.set global;
            Gfx.main_loop update (fun () -> ()))))



