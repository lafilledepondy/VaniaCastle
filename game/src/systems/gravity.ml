open Ecs
open Component_defs

type t = movable

let init _ = ()

let update _ el =
  Seq.iter (fun e ->
    let v = e#velocity#get in
    if e#falling#get && v.Vector.y < Cst.max_fall_speed then (e#velocity#set Vector.{x=v.x; y=v.y +. Cst.gravity});
    e#falling#set true
  ) el