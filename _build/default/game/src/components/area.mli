open Component_defs

type tag += Area

(**
Créée une zone avec
- x_orr la coordonnée en abscisse de l'écran initial sur la carte
- y_orr idem en ordonnée
- width la largeur de la zone (en pixels)
- height sa hauteur
- elts la liste des éléments interactables présents dans la zone
- tex la texture de la zone
- walls la liste des murs/plateformes/warpzones de la zone
- enemies la liste des ennemis présents dans la zone
*)
val area : int * int * int *int * interactable list * Texture.t * contactBox list * enemy list -> area

(**
Déplace la zone et ses murs dans la direction pointée par v
*)
val move_area : area -> Vector.t -> unit

(**
Créée une zone entièrement vide
*)
val void : unit -> area

(**
Charge dans les différents systèmes l'entièreté du contenu d'une zone (elle-même,
ses murs, ses ennemis et ses interactables)
*)
val load : area -> unit

(**
Retire des différents systèmes l'entièreté du contenu d'une zone (elle-même,
ses murs, ses ennemis et ses interactables)
*)
val unload : area -> unit

(**
Met en pause la zone passée en paramètre
*)
val pause : area -> unit

(**
Enlève l'état de pause à la zone passée en paramètre
*)
val unpause : area -> unit