open Ecs
open Component_defs


type t = drawable

let init _ = ()

let update _dt el =
  let Global.{window;ctx;_} = Global.get () in
  let surface = Gfx.get_surface window in
  Texture.draw ctx surface (Vector.zero) (Rect.{width=800; height=600}) (Vector.zero) (!Cst.backGround);
  for prio = 1 to 5 do
    Seq.iter (fun (e:t) ->
        if e#priority#get = prio then
          (let pos = Vector.add e#position#get e#visual_offset#get in
          let box = if e#has_offset#get then e#visual_box#get else e#box#get in
          let txt = e#texture#get in
          let (texX, texY, _) = e#animation_index#get in
          let l = e#left#get in
          let extractX = if l then float ((e#file_width#get)-((texX+1)*box.Rect.width)) else float (texX*box.Rect.width) in
          let extractY = float (texY*box.Rect.height) in 
          let extractPos = Vector.{x=extractX; y=extractY} in
          Texture.draw ctx surface pos box extractPos txt;)
      ) el
  done;
  Gfx.commit ctx