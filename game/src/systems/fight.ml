open Ecs
open Component_defs


type t = fighter

let init _ = ()

let update _dt el =
  Seq.iter (fun e ->
    match e#tag#get with
    | Enemy(e, Melee) ->
      if e#attacking#get then
        (let cool = e#cooldown#get in
        let prep = e#atq_prep#get in
        if fst(cool) = snd(cool) && fst(prep) > 0 then (*Si un ennemy peut attaquer, il s'y prépare*)
          (e#atq_prep#set (fst(prep)-1, snd(prep));
          e#current_animation#set Idle;
          e#velocity#set (Vector.zero))
        else if fst(cool) = snd(cool) && fst(prep) = 0 then (*S'il est prêt, il attaque*)
          (e#atq_prep#set (snd(prep), snd(prep));
          e#cooldown#set (fst(cool)-1, snd(cool));
          e#current_animation#set Atk;
          let (y, maxX) = Hashtbl.find e#frame_set#get Atk in
          e#animation_index#set (0, y, maxX);
          e#create_projectile#get ())
        else if fst(cool) = 0 then (*Si son cooldown est à 0, il peut à nouveau attaquer*)
          (e#cooldown#set (snd(cool), snd(cool));
          e#attacking#set false;
          e#velocity#set Vector.{x=e#default_speed#get; y=0.};
          e#left#set false)
        else (*Sinon, il faut décrémenter son cooldown*)
          e#cooldown#set (fst(cool)-1, snd(cool)))
      else (*Si un ennemy n'est pas en train d'attaquer, il regarde s'il devrait*)
        (let p = (Global.get()).player in
        let pPos = p#position#get in
        let pBox = p#box#get in
        let ePos = e#position#get in
        let eBox = e#box#get in
        let rad = e#atq_radius#get in
        let atqBoxPos = Vector.(
          let y=ePos.y in
          if (e#left#get) then
            {x=ePos.x -. (float rad) ; y}
          else
            {x=ePos.x+. (float eBox.Rect.width); y}
        )
        in
        let atqBox = Rect.{width=rad; height=eBox.height} in
        if Rect.intersect pPos pBox atqBoxPos atqBox then
          e#attacking#set true;)
    | Enemy(e, Shooter) ->
      let cool = e#cooldown#get in
      if fst(cool) = 0 then
        e#cooldown#set (snd(cool), snd(cool))
      else if fst(cool) != snd(cool) then
        e#cooldown#set (fst(cool)-1, snd(cool))
      else (*Dès qu'il peut, un ennemy tireur tire*)
        let p = (Global.get ()).player in
        let pPos = p#position#get in
        let pBox = p#box#get in
        let rad = float (e#atq_radius#get/2) in
        let sPos = e#position#get in
        let sBox = e#box#get in
        let w = float (sBox.Rect.width/2) in
        let h = float (sBox.Rect.height/2) in
        let detecBoxPos = Vector.{x = sPos.x -. rad +. w; y=sPos.y -. rad +. h} in
        let rad = e#atq_radius#get in
        let width, height = rad, rad in
        let detectBox = Rect.{width; height} in
        if Rect.intersect pPos pBox detecBoxPos detectBox then
          (e#cooldown#set (fst(cool)-1, snd(cool));
          e#current_animation#set Atk;
          let (y, maxX) = Hashtbl.find e#frame_set#get Atk in
          e#animation_index#set (0, y, maxX);
          e#create_projectile#get ())
    | _ -> failwith "unreachable"
  ) el