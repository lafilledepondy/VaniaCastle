open Component_defs

type tag += 
  | Ceiling of contactBox 
  | Floor of contactBox 
  | Wall of contactBox 
  | Platform of contactBox 
  | Warp of contactBox*area*(int -> int)*(int -> int)
  | Click of contactBox*(unit->unit)

(**
Type spécial pour identifier la catégorie à laquelle appartient une boîte
*)
type boxCat = 
  | Ceiling
  | Floor
  | Wall
  | Platform
  | Warp
  | Click

(**
Crée une boîte avec les paramètres suivants :
- x son abscisse
- y son ordonnée
- width sa largeur
- height sa hauteur
- tex sa texture
- cat sa catégorie (Ceiling, Floor, etc...)
*)
val create : int * int * int * int * Texture.t * boxCat -> contactBox

(**
Crée une boîte de téléportation avec les paramètres suivants :
- x son abscisse
- y son ordonnée
- width sa largeur
- height sa hauteur
- tex sa texture
- (a, x_offset, y_offset) a la zone de destination,
    x_offset une fonction qui calcule le décalage en abscisse de l'entité qui emprunte la boîte
    y_offset idem pour l'ordonnée
*)
val createWarp : int * int * int * int * Texture.t * (area * (int -> int) * (int -> int)) -> contactBox

(**
Déplace une boîte dans la direction donnée par le vecteur v
*)
val move_box : contactBox -> Vector.t -> unit

(**
Crée une zone rectangulaire de la taille de l'écran (pour les tests)
*)
val default : unit -> contactBox list

(**
Crée les murs d'une zone de test
*)
val wallsZ1 : unit -> contactBox list

(**
Crée les murs d'une zone de test
*)
val testBoxes : unit -> contactBox list

(**
Crée les murs d'une zone de test
*)
val testBoxesMirr : unit -> contactBox list