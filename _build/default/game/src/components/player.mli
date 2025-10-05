open Component_defs

type tag += Player

(**
Crée un player avec les paramètres suivants :
- name son nom
- x son abscisse
- y son ordonnée
- txt sa texture
- width la largeur de sa hitbox
- height la hauteur de sa hitbox
Et l'ajoute aux Draw, Collision et Move systems
*)
val player : string * int * int * Texture.t * int * int -> player

(**
Crée un player pour les tests
*)
val players : unit -> player

(**
Récupère le player dans l'état et le renvoie
*)
val player1 : unit -> player

(**
Met la valeur du vecteur de déplacement du joueur à (0, 0)
*)
val completly_stop_players : unit -> unit

(**
Met la vitesse de déplacement horizontal du joueur à 0
*)
val horizontally_stop_players : unit -> unit

(**
Met le vecteur de déplacement du player passé en paramètre à v
*)
val move_player : player -> Vector.t -> unit

(**
Déplace le player passé en paramètre dans la direction pointée par le vecteur v
*)
val replace_player : player -> Vector.t -> unit

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
Affiche l'inventaire du player passé en argument
*)
val print_inventory : player -> unit

(**
Met en pause le joueur passé en paramètre
*)
val pause : player -> unit

(**
Enlève l'état de pause au joueur passé en paramètre
*)
val unpause : player -> unit