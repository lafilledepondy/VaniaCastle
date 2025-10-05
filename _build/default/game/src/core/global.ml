open Component_defs


type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  player : player;
  mutable waiting : bool;
  mutable area : area;
  deb : float;
}

let state = ref None

let get () : t =
  match !state with
    None -> failwith "Uninitialized global state"
  | Some s -> s

let set s = state := Some s
