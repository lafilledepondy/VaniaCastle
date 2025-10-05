open Ecs
open Component_defs

type t = expirable

let init _ = ()

let prec = ref 0.

let update _dt el =
  let g = Global.get () in
  if g.waiting then (*Tant que le jeu est en pause, on augmente le temps de vie des objets qui en ont un*)
    begin
      let delta = Sys.time() -. !prec in
      Cst.time_limit := !Cst.time_limit +. delta;
      Seq.iter (fun (e : t) ->
        e#duration#set (e#duration#get +. delta)
      ) el
    end
  else
    (*Si la durée de vie d'un objest est expiré, on le supprime*)
    begin
      let start = g.deb in
      if (Sys.time ()) >= (!Cst.time_limit +. start) then (); (*Game Over*)
      Seq.iter (fun (e:t) ->
          let b = e#birth#get in
          if b = infinity then ()
          else
            let time_of_death = b +. e#duration#get in
            if (Sys.time ()) -. start >= time_of_death then
              (e#delete#get ())
        ) el;
    end;
  prec := Sys.time ()