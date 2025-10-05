open Component_defs

(**
Type de l'état du jeu
*)
type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  player : player;
  mutable started : bool;
  mutable screen : contactBox option;
  mutable waiting : bool;
  mutable dead : bool;
  mutable area : area;
  mutable projectiles : projectile list;
  mutable current_target : enemy option;
  boss : enemy;
  healthBar : contactBox;
  enemyHealthBar : contactBox;
  manaBar : contactBox;
  deb : float;
}

(**
Supprime le projectile p de l'état du jeu
*)
val removeProjectile : projectile -> unit

(**
Renvoie l'état du jeu
*)
val get : unit -> t

(**
Remplace l'état du jeu par g
*)
val set : t -> unit
