open Ecs
open Component_defs
open System_defs



type projCat = Hit | Throw | Attack | Magic


(*Supprime le projectile p et autorise les ennemis qu'il avait touchés à être frappés à nouveau*)
let del p _ =
  Draw_system.(unregister (p :> t));
  Collision_system.(unregister (p :> t));
  Time_system.(unregister (p :> t));
  Move_system.(unregister (p :> t));
  Gravity_system.(unregister (p :> t));
  Global.removeProjectile p;
  List.iter (fun e -> e#hit#set false) p#hitted#get



let projectile (x, y, txt, width, height, atq, time, speedX, speedY, cat, fall) =
  let p = new projectile () in
  p#priority#set 3;
  p#texture#set txt;
  p#position#set Vector.{x = float x; y = float y};
  p#velocity#set Vector.{x = speedX; y = speedY};
  p#box#set Rect.{width; height};
  p#file_width#set width;
  p#duration#set time;
  p#atq#set atq;
  p#birth#set (Sys.time ());
  p#delete#set (del p);
  p#tag#set (
    match cat with
    | Hit -> DmgZone(p)
    | Throw -> p#mass#set 3.; Projectile(p)
    | Attack -> Attack(p)
    | Magic -> p#mass#set 3.; Magic(p)
  );
  let g = Global.get () in
  g.projectiles <- p::g.projectiles;
  Draw_system.(register (p :> t));
  Collision_system.(register (p :> t));
  Time_system.(register (p :> t));
  Move_system.(register (p :> t));
  if fall then Gravity_system.(register (p :> t));
  p