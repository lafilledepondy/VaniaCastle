open System_defs
open Component_defs
open Ecs

let update dt =
  Time_system.update dt;
  let g = Global.get () in
  begin
    if g.started then
      (if not(g.dead) then
        (if not(g.waiting) then
          (begin
          let p = g.player in
          (if p#invincibility#get = 0 then
            Player.horizontally_stop_players ());
          let cool = p#cooldown#get in
          (if fst(cool) = 0 then p#cooldown#set (snd cool, snd cool)
          else if (fst cool) <> (snd cool) then p#cooldown#set ((fst cool)-1, snd cool));
          Player.decrement_coyote p;
          Player.decrement_invincibility p;
          let b = g.boss in
          let pdead = p#health#get <= 0 in
          let bdead = b#health#get <= 0 in
          if pdead || bdead then
            (let a = g.area in
            let proj = g.projectiles in
            Area.unload a;
            List.iter (fun p -> p#delete#get ()) proj;
            Draw_system.(unregister (g.healthBar :> t));
            Draw_system.(unregister (g.enemyHealthBar :> t));
            Draw_system.(unregister (g.manaBar :> t));
            Player.unload p;
            if pdead then g.screen <- Some (Box.gameOverScreen ());
            if bdead then g.screen <- Some (Box.winningScreen ());
            g.dead <- true)
          end);
        let () = Input.handle_input () in
        if not((Global.get ()).waiting) then
          (Gravity_system.update dt;
          Collision_system.update dt;
          Box.update_health_bar ();
          Box.update_enemy_health_bar ();
          Box.update_mana_bar ();
          Animation_system.update dt;
          Draw_system.update dt;
          Move_system.update dt;
          Fight_system.update dt;
          Death_system.update dt))
      else ((*restart : non implémenté => CTRL + SHIFT + R*)))
    else
      let () = Input.handle_input () in
      Draw_system.update dt
  end;
  None

let run () =
  let window_spec = 
    Format.sprintf "game_canvas:%dx%d:"
      Cst.window_width Cst.window_height
  in
  let window = Gfx.create  window_spec in
  let ctx = Gfx.get_context window in
  let player = Player.createPlayer () in
  let fileZ1 = Gfx.load_image ctx "resources/images/testZone1.png" in
  let fileZ1Mirr = Gfx.load_image ctx "resources/images/testAreaMirror.png" in
  let inventoryMenu = Gfx.load_image ctx "resources/images/betaInventory.png" in
  let char_sprite = Gfx.load_image ctx "resources/images/characterFrameSetLeft.png" in
  let yelo = Gfx.load_image ctx "resources/images/yelo.png" in
  let fireballFile = Gfx.load_image ctx "resources/images/fireball.png" in
  let funnyRock = Gfx.load_image ctx "resources/images/dwayne.png" in
  let gameOver = Gfx.load_image ctx "resources/images/gameOver.png" in
  let w = Gfx.load_image ctx "resources/images/thatsAllFolks.png" in
  let titre = Gfx.load_image ctx "resources/images/VaniaCastle.png" in
  let fond = Gfx.load_image ctx "resources/images/bg.png" in
  let fondChateau = Gfx.load_image ctx "resources/images/fondMur.png" in
  let grass = Gfx.load_image ctx "resources/images/herbe1.png" in
  let solChateau = Gfx.load_image ctx "resources/images/castleGround.png" in
  let croixEnvers = Gfx.load_image ctx "resources/images/anticross.png" in
  let hache = Gfx.load_image ctx "resources/images/axeFrameset.png" in
  let bgBoss = Gfx.load_image ctx "resources/images/bossRoomBackGround.png" in
  let plafondChateau = Gfx.load_image ctx "resources/images/ceiling.png" in
  let calice = Gfx.load_image ctx "resources/images/chalice.png" in
  let cyclo = Gfx.load_image ctx "resources/images/cyclotorLaffreuxFrameset.png" in
  let man = Gfx.load_image ctx "resources/images/mana.png" in
  let skel = Gfx.load_image ctx "resources/images/skeletonFrameSet.png" in
  let plateformeJaune = Gfx.load_image ctx "resources/images/yellowPlatform.png" in
  let mur = Gfx.load_image ctx "resources/images/wall.png" in

  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt mur)
  (fun murTex ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt plateformeJaune)
  (fun plateformeJauneTex ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt skel)
  (fun skelTex ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt man)
  (fun manTex ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt cyclo)
  (fun cycloTex ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt calice)
  (fun caliceTex ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt plafondChateau)
  (fun plafondChateauTex ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt bgBoss)
  (fun bgBossTex ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt hache)
  (fun hacheTex ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt croixEnvers)
  (fun croixEnversTex ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt solChateau)
  (fun solChateauTex ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt grass)
  (fun grassTex ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt fondChateau)
  (fun backGroundCastle ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt fond)
  (fun backGroundTex ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt titre)
  (fun tImg ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt w)
  (fun wImg ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt gameOver)
  (fun gameOverImg ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt funnyRock)
  (fun funnyRockTex ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt fireballFile)
  (fun fireballTex ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt yelo)
  (fun yeloTex ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt char_sprite)
  (fun textChara ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt inventoryMenu)
  (fun textInventory ->
  Gfx.main_loop
  (fun _dt -> Gfx.get_resource_opt fileZ1)
  (fun texZ1 ->
  Gfx.main_loop 
  (fun _dt -> Gfx.get_resource_opt fileZ1Mirr)
  (fun texZ1Mirr ->
    Cst.fireBallTex := Image(fireballTex);
    Cst.gameOver := Image(gameOverImg);
    Cst.win := Image(wImg);
    Cst.title := Image(tImg);
    Cst.jonhsonTex := Image(funnyRockTex);
    Cst.backGround := Image(backGroundTex);
    Cst.castle := Image(backGroundCastle);
    Cst.grass := Image(grassTex);
    Cst.castleGround := Image(solChateauTex);
    Cst.antiCross := Image(croixEnversTex);
    Cst.axeTex := Image(hacheTex);
    Cst.bossRoomBg := Image(bgBossTex);
    Cst.castleCeiling := Image(plafondChateauTex);
    Cst.chalice := Image(caliceTex);
    Cst.cyclotorTex := Image(cycloTex);
    Cst.manaVial := Image(manTex);
    Cst.skeletonTex := Image(skelTex);
    Cst.yellowPlatform := Image(plateformeJauneTex);
    Cst.wallTex := Image(murTex);

    player#texture#set (Image(textChara));

    let skelFst = Enemy.skeletonsFirstArea () in
    let skelSnd = Enemy.skeletonsSecondArea () in
    let mauricesFst = Enemy.johnsonsFirstArea () in
    let mauricesSnd = Enemy.johnsonsSecondArea () in
    let boss = Enemy.cyclotorLaffreux 810 150 in

    let enemiesFst = List.append skelFst mauricesFst in
    let enemiesSnd = List.append skelSnd mauricesSnd in

    let area1 = Area.area (0, -1200, 7200, 2300, [], Box.boxesFirstArea (), enemiesFst) in
    let area2 = Area.area (0, -1200, 5600, 1800, [], Box.boxesSecondArea (), enemiesSnd) in
    let bossRoom = Area.area (0, -1200, 1600, 1800, [], Box.boxesBossRoom (), [boss]) in

    (*
    Création des 3 warp zone :
          Z1 <---> Z2 ---> BOSS
    *)
    let warp1 = Box.createWarp (7190, (-1301), 20, 600, Texture.transparent, (area2, (fun _ -> 5), (fun y -> y))) in
    let warp2 = Box.createWarp ((-50), 0, 55, 600, Texture.transparent, (area1, (fun _ -> 700), (fun y -> y))) in
    let warp3 = Box.createWarp (5550, -1200, 50, 460, Texture.transparent, (bossRoom, (fun _ -> 60), (fun _ -> 300))) in

    area1#walls#set (warp1::area1#walls#get);
    area2#walls#set (warp3::warp2::area2#walls#get);

    let screen = Some (Box.titleScreen ()) in

    let global = Global.{ window;
                          ctx;
                          player;
                          started=false;
                          screen;
                          waiting=false;
                          dead=false;
                          area=area1;
                          projectiles=[];
                          current_target=None;
                          boss;
                          healthBar=Box.healthBar;
                          enemyHealthBar=Box.enemyHealthBar;
                          manaBar=Box.manaBar;
                          deb=(Sys.time ())
                        }
    in 

    Global.set global;
    Gfx.main_loop update (fun () -> ())))))))))))))))))))))))))