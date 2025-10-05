open Component_defs


type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  player : player;
  mutable waiting : bool;
  mutable area : area;
  deb : float;
}

val get : unit -> t
val set : t -> unit
