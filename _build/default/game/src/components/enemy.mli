open Component_defs

type tag += Enemy of enemy

(**
Créée un enemy avec
- name son nom
- hp son nombre de points de vie
- x son abscisse
- y son ordonnée
- tex sa texture
- width la largeur de sa hitbox
- height la hauteur de sa hitbox
*)
val enemy : string * int * int * int * Texture.t * int * int -> enemy

(**
Stoppe l'ennemi passé en paramètre
*)
val stop : enemy -> unit

(**
Attribue le vecteur v comme vitesse à l'ennemi e
*)
val move : enemy -> Vector.t -> unit

(**
Charge une liste d'ennemis dans le Move System, le Collision System et le Draw System
*)
val load : enemy list -> unit

(**
Retire une liste d'ennemis du Move System, du Collision System et du Draw System
*)
val unload : enemy list -> unit

(**
Créé un ennemi très basique aux coordonnées x y
*)
val test_enemy : int -> int -> enemy