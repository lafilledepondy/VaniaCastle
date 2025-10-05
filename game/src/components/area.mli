open Component_defs

(**
area (x_orr, y_orr, width, height, elts, walls, enemies)
Créée une zone avec
- x_orr la coordonnée en abscisse de l'écran initial sur la carte
- y_orr idem en ordonnée
- width la largeur de la zone (en pixels)
- height sa hauteur
- elts la liste des éléments interactables présents dans la zone
- walls la liste des murs/plateformes/warpzones de la zone
- enemies la liste des ennemis présents dans la zone
*)
val area : int * int * int *int * interactable list * contactBox list * enemy list -> area

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
Recharge la zone passée en argument
*)
val reload : area -> unit