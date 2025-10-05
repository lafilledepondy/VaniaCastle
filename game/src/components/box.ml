open Component_defs
open System_defs



type boxCat =
  | Platform 
  | Warp
  | Click
  | Pretty
  | Block


(* ##### FONCTIONS DE CRÉATIONS ##### *)
let create (x, y, width, height, tex, cat) =
  let e = new contactBox () in
  e#position#set Vector.{x = float x; y = float y};
  e#priority#set 3;
  e#box#set Rect.{width; height};
  e#file_width#set width;
  e#texture#set tex;
  e#tag#set (match cat with
  | Platform -> Platform(e)
  | Warp -> failwith "Please use the correct create function for Warpzones"
  | Click -> failwith "Please use the correct create function for Click boxes"
  | Pretty -> Pretty(e)
  | Block -> Block(e));
  e

(*Pour créer une plateforme avec la texture d'herbe*)
let createGrass (x, y) =
  let g = create(x, y, 800, 140, !Cst.grass, Platform) in
  g#has_offset#set true;
  g#visual_offset#set Vector.{x=0.; y= -.37.}; (*Offset pour la perspective*)
  g#visual_box#set Rect.{width=800; height=175};
  g

(*Pour créer une plateforme avec la texture de sol de château*)
let createCastleGround (x, y) =
  let g = create(x, y, 800, 140, !Cst.castleGround, Platform) in
  g#has_offset#set true;
  g#visual_offset#set Vector.{x=0.; y= -.37.}; (*Offset pour la perspective*)
  g#visual_box#set Rect.{width=800; height=175};
  g

(*Pour créer une boîte de décor en spécifiant la priorité*)
let createPretty (x, y, width, height, tex, prio) =
  let b = create (x, y, width, height, tex, Pretty) in
  b#priority#set prio;
  b

let createWarp (x, y, width, height, tex, (a, x_offset, y_offset)) =
    let e = new contactBox () in
    e#position#set Vector.{x = float x; y = float y};
    e#priority#set 3;
    e#box#set Rect.{width; height};
    e#file_width#set width;
    e#texture#set tex;
    e#tag#set (Warp(e, a, x_offset, y_offset));
    e

(*Inutilisé*)
(*Était censée être utilisée pour créer une zone clicable*)
let createClick (x, y, width, height, tex, clic) =
  let e = new contactBox () in
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width; height};
  e#file_width#set width;
  e#texture#set tex;
  e#tag#set (Click(e, clic));
  e



(* ##### ÉCRANS SPÉCIAUX ##### *)
let gameOverScreen _ =
  let go = create (0, 0, 800, 600, !Cst.gameOver, Pretty) in
  Draw_system.(register (go :> t));
  go

let winningScreen _ =
  let w = create (0, 0, 800, 600, !Cst.win, Pretty) in
  Draw_system.(register (w :> t));
  w

let titleScreen _ =
  let t = create (0, 0, 800, 600, !Cst.title, Pretty) in
  Draw_system.(register (t :> t));
  t



(* ##### BARRES ##### *)
let healthBar =
  let e = create (20, 20, 200, 30, Texture.red, Pretty) in
  e#priority#set 5;
  e

let enemyHealthBar =
  let e = create (0, 0, 0, 0, Texture.red, Pretty) in
  e#priority#set 5;
  e

let manaBar =
  let e = create (20, 50, 180, 20, Texture.blue, Pretty) in
  e#priority#set 5;
  e



(* ##### MÀJ DES BARRES ##### *)
let update_health_bar _ =
  let g = Global.get () in
  let p = g.player in
  let hb = g.healthBar in
  (*Le passage par float est obligatoire sinon on obtient forcément 0*)
  let width = int_of_float (200.*.((float p#health#get)/.60.)) in
  let height = 30 in
  hb#box#set Rect.{width; height}

let update_mana_bar _ =
  let g = Global.get () in
  let p = g.player in
  let mb = g.manaBar in
  (*Le passage par float est obligatoire sinon on obtient forcément 0*)
  let width = int_of_float (180.*.((float p#mana#get)/.100.)) in
  let height = 20 in
  mb#box#set Rect.{width; height}

let update_enemy_health_bar _ =
  let g = Global.get () in
  let e = g.current_target in
  let hb = g.enemyHealthBar in
  match e with
  | None -> hb#box#set Rect.{width=0; height=0}
  | Some e ->
    begin
      (*Le passage par float est obligatoire sinon on obtient forcément 0*)
      let w = (200.*.((float e#health#get)/.(float e#max_health#get))) in
      hb#position#set Vector.{x=780.-.w; y=20.};
      let width = int_of_float w in
      let height = 30 in
      hb#box#set Rect.{width; height}
    end


let b = Texture.black
let t = Texture.transparent
(* ##### CRÉATION DES BOÎTES DES ZONES ##### *)
let boxesFirstArea () =
  let g = List.map createGrass [
    (0, 499);
    (800, 499);
    (1600, 499);
    (2400, 499);
    (3200, 499);
    (4000, 499);
    (4800, 499);
    (5600, -101);
    (6400, -701)
  ] in
  let p = List.map create [
    (*black*)
    (5600, 30, 800, 800, b, Platform);
    (6400, (-591), 800, 1500, b, Platform);
    (*yellow*)
    (5456, 145, 144, 48, !Cst.yellowPlatform, Platform);
    (6256, (-463), 144, 48, !Cst.yellowPlatform, Platform);
    (*transparent*)
    ((-50), 0, 55, 600, t, Platform);
  ] in
  List.append g p

let boxesSecondArea () =
  let ground = List.map createCastleGround [
    (0, 499);
    (800, 499);
    (1600, 499);
    (2400, 499);
    (3200, 499);
    (4000, 499);
    (4800, 499);
    (2400, -101);
    (3200, -101);
    (4000, -101);
    (3200, -701);
    (4000,-701);
    (4800, -701);
  ] in
  let plat= List.map create [
    (*yellow platforms*)
    (5102, 129, 144, 48, !Cst.yellowPlatform, Platform);
    (2664, (-465), 144, 48, !Cst.yellowPlatform, Platform);
    (*walls*)
    (5552, -600, 48, 1099, !Cst.wallTex, Platform);
    (2352, -1200, 48, 1200, !Cst.wallTex, Platform);
  ]
  in
  let pretties = List.map createPretty [
    (*floor 0 pretties*)
    (0, 0, 800, 600, !Cst.castle, 2);
    (800, 0, 800, 600, !Cst.castle, 2);
    (1600, 0, 800, 600, !Cst.castle, 2);
    (2400, 0, 800, 600, !Cst.castle, 2);
    (3200, 0, 800, 600, !Cst.castle, 2);
    (4000, 0, 800, 600, !Cst.castle, 2);
    (4800, 0, 800, 600, !Cst.castle, 2);
    (*floor 1 pretties*)
    (2400, -600, 800, 600, !Cst.castle, 2);
    (3200, -600, 800, 600, !Cst.castle, 2);
    (4000, -600, 800, 600, !Cst.castle, 2);
    (4800, -600, 800, 600, !Cst.castle, 2);
    (*floor 2 pretties*)
    (2400, -1200, 800, 600, !Cst.castle, 2);
    (3200, -1200, 800, 600, !Cst.castle, 2);
    (4000, -1200, 800, 600, !Cst.castle, 2);
    (4800, -1200, 800, 600, !Cst.castle, 2);
    (*Ceilings*)
    (0, -50, 800, 100, !Cst.castleCeiling, 3);
    (740, -50, 800, 100, !Cst.castleCeiling, 3);
    (1480, -50, 800, 100, !Cst.castleCeiling, 3);
    (2352, -1250, 800, 100, !Cst.castleCeiling, 3);
    (3092, -1250, 800, 100, !Cst.castleCeiling, 3);
    (3832, -1250, 800, 100, !Cst.castleCeiling, 3);
    (4572, -1250, 800, 100, !Cst.castleCeiling, 3);
    (5312, -1250, 800, 100, !Cst.castleCeiling, 3);
    (6052, -1250, 800, 100, !Cst.castleCeiling, 3);
  ] in
  let l1 = List.append plat pretties in
  List.append ground l1


let boxesBossRoom () =
  let g1 = createCastleGround (0, 499) in
  let g2 = createCastleGround (800, 499) in
  let bg = createPretty (0, -1320, 1600, 1800, !Cst.bossRoomBg, 2) in
  let w1 = create (0, -1200, 48, 1660, !Cst.wallTex, Platform) in
  let w2 = create (1552, -1200, 48, 1660, !Cst.wallTex, Platform) in
  g1::g2::bg::w1::w2::[] (*Tout écrit à la main pour éviter des appels à append sur de petites listes*)