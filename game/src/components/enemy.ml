open Ecs
open Component_defs
open System_defs



(* Tue un ennemy, autrement dit, le supprime des systèmes et crée son loot *)
let die e _ =
  Draw_system.(unregister (e :> t));
  Collision_system.(unregister (e :> t));
  Death_system.(unregister (e :> t));
  Fight_system.(unregister (e :> t));
  Move_system.(unregister (e :> t));
  Animation_system.(unregister (e :> t));
  let Vector.{x; y} = e#position#get in
  let Rect.{width; height} = e#box#get in
  let centerX = x +. ((float width)/.2.) in
  let centerY = y +. ((float height)/.2.) in
  let d = ((Random.int 100000) mod 100) in
  let drop =
    (if d < 25 then
      Interactable.healingChalice (int_of_float centerX) (int_of_float centerY)
    else if d < 75 then
      Interactable.antiCross (int_of_float centerX) (int_of_float centerY)
    else
      Interactable.manaVial (int_of_float centerX) (int_of_float centerY)
    )
  in
  let g = (Global.get ()) in
  g.current_target <- None;
  let a = g.area in
  a#elements#set (drop::(a#elements#get));
  Interactable.load drop



(* Crée une zone de dégâts émise par l'enemy e *)
let damage_box e _ =
  let ePos = e#position#get in
  let eBox = e#box#get in
  let dmg = e#dmg_box#get in
  let w = dmg.Rect.width in
  let x =
    if e#left#get then
      int_of_float (ePos.Vector.x -. (float w))
    else
      int_of_float (ePos.x+. (float eBox.Rect.width))
  in
  let h = dmg.Rect.height in
  let atq = e#atq#get in
  let time = 0.2 in
  let y=int_of_float ePos.Vector.y in
  let _ = Projectile.projectile (x, y, Texture.transparent, w, h, atq, time, 0., 0., Projectile.Hit, false) in
  ()



let enemy (name, hp, x, y, atq, rad, txt, width, height) =
  let e = new enemy name in
  e#priority#set 4;
  e#mass#set 1.;
  e#texture#set txt;
  e#tag#set (Enemy (e, Melee));
  e#health#set hp;
  e#max_health#set hp;
  e#atq#set atq;
  e#detection_radius#set rad;
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width; height};
  e#file_width#set width;
  e#velocity#set Vector.{x=Cst.default_enemy_speed; y=0.};
  e#create_projectile#set (damage_box e);
  e#delete#set (die e);
  e



(*Calcule la position de la boîte de détection d'un ennemy e*)
let detect_box_pos e =
  let rad = float (e#detection_radius#get/2) in
  let sPos = e#position#get in
  let sBox = e#box#get in
  let w = float (sBox.Rect.width/2) in
  let h = float (sBox.Rect.height/2) in
  Vector.(
  let x = sPos.x -. rad +. w in
  let y = sPos.y -. rad +. h in
  {x; y})



(* ##### SQUELETTE ##### *)
(*Pattern de déplacement du squelette*)
let skeleton_pattern s _ =
  if not(s#attacking#get) then s#current_animation#set Walk; (*Il se remet a marcher ssi il a fini d'attaquer*)
  let rad = s#detection_radius#get in
  let radBox = Rect.{width=rad; height=rad} in
  let radPos = detect_box_pos s in
  let p = (Global.get ()).player in
  let pBox = p#box#get in
  let pPos = p#position#get in
  let rebound_vec = Rect.rebound radPos radBox pPos pBox in
  let mdiff = Rect.mdiff radPos radBox pPos pBox in
  let penetration = Rect.penetration_vector (fst mdiff) (snd mdiff) in
  (*
  Si le joueur est dans sa boîte de détection mais pas en contact direct avec lui,
  il s'en approche, sinon, il ne fait rien
  *)
  match rebound_vec with
  | None -> ()
  | Some v ->
    let speed = s#velocity#get in
    let sBox = s#box#get in
    let sPos = s#position#get in
    let inter = Rect.intersect  sPos sBox pPos pBox in
    if not(inter) then
      begin
        if penetration.x  < 0. then
          (s#velocity#set Vector.{x = -.Cst.default_enemy_speed; y=speed.y};
          s#left#set true)
        else
          (s#velocity#set Vector.{x = Cst.default_enemy_speed; y=speed.y};
          s#left#set false)
      end

let bloodySkeleton =
  let id = ref 0 in
  fun x y ->
    id := !id + 1;
    let name = "Skeleton"^(string_of_int !id) in
    let s = enemy (name, 30, x, y, 5, 300, !Cst.skeletonTex, 86, 191) in
    s#pattern#set (skeleton_pattern s);
    s#atq_radius#set 50;
    s#cooldown#set (180, 180);
    s#atq_prep#set (120, 120);
    s#dmg_box#set s#box#get;
    s#visual_box#set Rect.{width=258; height=191};
    s#visual_offset#set Vector.{x= -.86.; y=0.};
    s#has_offset#set true;
    s#file_width#set 3096;
    Hashtbl.add (s#frame_set#get) Idle (0, 0);
    Hashtbl.add (s#frame_set#get) Atk (2, 5);
    Hashtbl.add (s#frame_set#get) Walk (1, 1);
    s


  
(* ##### BATFROG ##### *)
(* Inutilisé *)
(*
Devait être une grenouille avec des ailes de chauve-souris
qui se déplace en sautant et inflige des dégâtes au contact.
N'a pas eu le temps d'être réelement implémentée
*)
let batFrog =
  let id = ref 0 in
  fun x y ->
    id := !id + 1;
    let name = "Frog"^(string_of_int !id) in
    enemy (name, 10, x, y, 2, 0, Texture.green, 0, 0) (*remplacer par les bonnes dimensions et radius*)



(* ##### DWAYNETHESTONEFACEJONHSON ##### *)
(* Calcule le vecteur vitesse d'une boule de feu pour qu'elle se dirige vers le joueur *)
let dir_fireball x y =
  let p = (Global.get ()).player in
  let pPos = p#position#get in
  let pBox = p#box#get in
  let px, py = Vector.(pPos.x, pPos.y) in
  let pw, ph = Rect.(pBox.width, pBox.height) in
  let centerPlayerX = px +. (float (pw/2)) in
  let centerPlayerY = py +. (float (ph/2)) in
  let centerPlayer = Vector.{x=centerPlayerX; y=centerPlayerY} in
  let directionVector = Vector.sub centerPlayer Vector.{x; y} in
  Vector.mult 7. (Vector.normalize directionVector)

(* Crée une boule de feu ciblant le joueur *)
let fireball e _ =
  let ePos = e#position#get in
  let x = ePos.Vector.x +. 29. in
  let y = ePos.Vector.y +. 96. in
  let w, h = 50, 50 in
  let atq = e#atq#get in
  let time = 10. in
  let dir = dir_fireball x y in
  let _ = Projectile.projectile (int_of_float x, int_of_float y, !Cst.fireBallTex, w, h, atq, time, dir.Vector.x, dir.Vector.y, Projectile.Throw, false) in
  ()

let stoneFace =
  let id = ref 0 in
  fun x y ->
    id := !id + 1;
    let name = "DwayneTheStoneFaceJohnson"^(string_of_int !id) in
    let s = enemy (name, 50, x, y, 7, 1200, !Cst.jonhsonTex, 109, 138) in
    s#tag#set (Enemy (s, Shooter));
    s#atq_radius#set s#detection_radius#get;
    s#cooldown#set (300, 300);
    s#create_projectile#set (fireball s);
    s#velocity#set Vector.zero;
    s#default_speed#set 0.;
    s#pattern#set (fun () -> s#falling#set false);
    s#mass#set infinity;
    s#file_width#set 109;
    Hashtbl.add (s#frame_set#get) Idle (0, 0);
    Hashtbl.add (s#frame_set#get) Atk (1, 2);
    Hashtbl.add (s#frame_set#get) Walk (0, 0);
    s

  
  
(* ##### CYCLOTOR L'AFFREUX ##### *)
(*Pattern de déplacement de Cyclotor*)
let cyclotor_pattern c _ =
  c#current_animation#set Walk;
  let rad = c#detection_radius#get in
  let radBox = Rect.{width=rad; height=rad} in
  let radPos = detect_box_pos c in
  let p = (Global.get ()).player in
  let pBox = p#box#get in
  let pPos = p#position#get in
  let rebound_vec = Rect.rebound radPos radBox pPos pBox in
  let mdiff = Rect.mdiff radPos radBox pPos pBox in
  let penetration = Rect.penetration_vector (fst mdiff) (snd mdiff) in
  match rebound_vec with
  | None -> (*Si le player n'est pas détecté, 0.025% de chances de changer de direction*)
    let v = c#velocity#get in
    let x = v.Vector.x in
    let d = Random.int 10000 in
    if d > 250 then ()
    else c#velocity#set Vector.{x = -.x; y=v.y}
  | Some v -> (*Sinon, s'éloigner lentement du player*)
    let speed = c#velocity#get in
    let sBox = c#box#get in
    let sPos = c#position#get in
    let inter = Rect.intersect  sPos sBox pPos pBox in
    if not(inter) then
      begin
        if penetration.x  < 0. then
          (c#velocity#set Vector.{x = Cst.default_enemy_speed/.2.; y=speed.y};
          c#left#set true)
        else
          (c#velocity#set Vector.{x = -.Cst.default_enemy_speed/.2.; y=speed.y};
          c#left#set false)
      end

(* Calcule la vitesse d'une hache pour qu'elle est un mouvement en cloche dont le point d'arrivée est le centre du player*)
let x_speed_axe x y =
  let p = (Global.get ()).player in
  let pPos = p#position#get in
  let pBox = p#box#get in
  let px, py = Vector.(pPos.x, pPos.y) in
  let pw, ph = Rect.(pBox.width, pBox.height) in
  let centerPlayerX = px +. (float (pw/2)) in
  let centerPlayerY = py +. (float (ph/2)) in
  let centerPlayer = Vector.{x=centerPlayerX; y=centerPlayerY} in
  let directionVector = Vector.sub centerPlayer Vector.{x; y} in
  let dist = Vector.norm directionVector in
  if px > x then
    dist/.60.
  else
    (-.dist)/.60.

(* Crée une hache *)
let axe e _ =
  let ePos = e#position#get in
  let x = ePos.Vector.x +. 29. in
  let y = ePos.Vector.y +. 96. in
  let w, h = 70, 70 in
  let atq = e#atq#get in
  let time = 15. in
  let speedY = -.18. in
  let speedX = x_speed_axe x y in
  let a = Projectile.projectile (int_of_float x, int_of_float y, !Cst.axeTex, w, h, atq, time, speedX, speedY, Projectile.Throw, true) in
  Hashtbl.add (a#frame_set#get) Idle (0, 3);
  a#file_width#set 280;
  a#animation_index#set (0, 0, 3);
  Animation_system.(register (a :> t))

let cyclotorLaffreux =
  let id = ref 0 in
  fun x y ->
    id := !id + 1;
    let name = "cyclotor"^(string_of_int !id) in
    let c = enemy (name, 500, x, y, 15, 600, !Cst.cyclotorTex, 160, 300) in (*remplacer par les bonnes dimensions*)
    c#atq_radius#set 2000;
    c#pattern#set (cyclotor_pattern c);
    c#create_projectile#set (axe c);
    c#cooldown#set (60, 60);
    c#file_width#set 640;
    Hashtbl.add (c#frame_set#get) Idle (0, 0);
    Hashtbl.add (c#frame_set#get) Walk (1, 1);
    Hashtbl.add (c#frame_set#get) Atk (2, 1);
    (* Projectile en cloche : vitesse en x fixe, accélération en y, la gravité fait le reste *)
    c#tag#set (Enemy (c, Shooter));
    c



(* ##### CRÉATIONS SQUELETTES ##### *)
let skeletonsFirstArea () =
  let s1 = bloodySkeleton 2410 300 in
  let s2 = bloodySkeleton 4810 300 in
  let s3 = bloodySkeleton 6992 (-900) in
  [s1; s2; s3]

let skeletonsSecondArea () =
  let s1 = bloodySkeleton 1664 300 in
  let s2 = bloodySkeleton 3336 300 in
  let s3 = bloodySkeleton 5004 300 in
  let s4 = bloodySkeleton 4104 (-900) in
  let s5 = bloodySkeleton 4908 (-900) in
  [s1; s2; s3; s4; s5]



(* ##### CRÉATIONS JOHNSONS ##### *)
let johnsonsFirstArea () =
  let j1 = stoneFace 5968 (-600) in
  let j2 = stoneFace 7056 (-1000) in
  let j3 = stoneFace 7056 (-1300) in
  [j1; j2; j3]

let johnsonsSecondArea () =
  let j1 = stoneFace 5018 (-450) in
  let j2 = stoneFace 2962 (-1070) in
  [j1; j2]