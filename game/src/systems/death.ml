open Ecs
open Component_defs


type t = mortal

let init _ = ()

let update _dt el =
    Seq.iter (fun (e:t) -> if e#health#get <= 0 then e#delete#get ()) el