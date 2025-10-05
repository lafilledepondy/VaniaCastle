open Ecs
open Component_defs

type t = expirable

let init _ = ()

let update _dt el =
  let start = (Global.get ()).deb in
  if (Sys.time ()) >= (Cst.time_limit +. start) then (); (*Game Over*)
  Seq.iter (fun (e:t) ->
      let b = e#birth#get in
      if b = infinity then ()
      else
        let time_of_death = b +. e#duration#get in
        if (Sys.time ()) -. start >= time_of_death then
          (e#delete#get ())
    ) el
