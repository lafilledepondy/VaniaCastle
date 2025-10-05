open Component_defs

(**
enemy(name, hp, x, y, atq, rad, tex, width, height)
Créée un enemy avec
- name son nom
- hp son nombre de points de vie
- x son abscisse
- y son ordonnée
- atq ses points d'attaque
- rad son rayon de détection du player
- tex sa texture
- width la largeur de sa hitbox
- height la hauteur de sa hitbox
*)
val enemy : string * int * int * int * int * int * Texture.t * int * int -> enemy

(**
Crée un squelette aux coordonnées x y et le renvoie
*)
val bloodySkeleton : int -> int -> enemy

(**
Crée un johnson aux coordonnées x y et le renvoie
*)
val stoneFace : int -> int -> enemy

(**
Crée un cyclotor l'affreux aux coordonnée x y et le renvoie
*)
val cyclotorLaffreux : int -> int -> enemy

(**
Crée la liste des squelettes de la première zone
*)
val skeletonsFirstArea : unit -> enemy list

(**
Crée la liste des squelettes de la seconde zone
*)
val skeletonsSecondArea : unit -> enemy list

(**
Crée la liste des johnsons de la première zones
*)
val johnsonsFirstArea : unit -> enemy list

(**
Crée la liste des johnsons de la seconde zone
*)
val johnsonsSecondArea : unit -> enemy list