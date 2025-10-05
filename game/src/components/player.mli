open Component_defs

(**
Crée un player avec les paramètres suivants :
- name son nom
- x son abscisse
- y son ordonnée
- txt sa texture
- width la largeur de sa hitbox
- height la hauteur de sa hitbox
Et le renvoie
*)
val player : string * int * int * Texture.t * int * int -> player

(**
Crée le player
*)
val createPlayer : unit -> player

(**
Récupère le player dans l'état et le renvoie
*)
val player1 : unit -> player

(**
Met la vitesse de déplacement horizontal du joueur à 0
*)
val horizontally_stop_players : unit -> unit

(**
Met la vitesse de déplacement horizontal de player à x
*)
val walk : player -> float -> unit

(**
Si possible, fait sauter le player en paramètre. Ne fait rien sinon
*)
val jump : player -> unit

(**
Décrémente le coyote time du player (s'il est supérieur à 0)
*)
val decrement_coyote : player -> unit

(**
Décrémente le nombre de frames d'invincibilité restantes du player (s'il est supérieur à 0)
*)
val decrement_invincibility : player -> unit

(**
Affiche l'inventaire du player passé en argument
*)
val print_inventory : player -> unit

(**
Décharge le joueur passé en paramètre (le supprime des divers systèmes)
*)
val unload : player -> unit

(**
Charge le joueur passé en paramètre (l'ajoute aux divers systèmes)
*)
val load : player -> unit

(**
Crée une boule de feu tirée par le player p
*)
val fireball : player -> unit

(**
Crée une attaque de mêlée lancée par le player p
*)
val attack : player -> unit