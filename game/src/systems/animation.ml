open Ecs
open Component_defs


type t = animated

let init _ = ()

(*Référence qui permet de ne faire progresser le système d'animation qu'un frame sur 3*)
let anim = ref 0

let update _dt el =
  if !anim = 0 then
    (Seq.iter (fun (e:t) ->
      let curr = e#current_animation#get in
      let prev = e#previous_animation#get in
      e#previous_animation#set curr;
      if curr = Atk then (*L'animation d'attaque est prioritaire sur les autres*)
        begin
          let (x, y, maxX) = e#animation_index#get in
          if x < maxX then
            e#animation_index#set (x+1, y, maxX)
          else
            (e#current_animation#set Idle;
            e#animation_index#set (0, 0, 0))
        end
      else if curr = prev then (*Si l'animation n'a pas changé, on la continue*)
        begin
          let (x, y, maxX) = e#animation_index#get in
          if x < maxX then
            e#animation_index#set (x+1, y, maxX)
          else
            e#animation_index#set (0, y, maxX)
        end
      else (*Sinon, on débute la nouvelle*)
        begin
          let (y, maxX) = Hashtbl.find e#frame_set#get curr in
          e#animation_index#set (0, y, maxX)
        end
    ) el;
    anim := !anim + 1)
  else
    (anim := !anim + 1;
    if !anim = 3 then anim := 0)