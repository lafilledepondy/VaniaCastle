open Component_defs

type tag += 
    | OtherItem of interactable
    | CollectableItem of interactable


(**
Type spécial pour identifier la catégorie à laquelle appartient un interactable 
*)
type interType = 
    | OtherItem
    | CollectableItem

(**
Crée un interactable avec les paramètres suivants :
- x son abscisse
- y son ordonnée
- txt sa texture
- width la largeur de sa hitbox
- height la hauteur de sa hitbox
- action l'action a effectuer lorsque l'on intéragit avec
- time sa durée de vie
- intertype 
*)
val interactable : string * int * int * Texture.t * int * int * (unit -> unit) * float * interType -> interactable 

(**
Retire un interactable des Draw et Collision systems
*)
val remove_interactable : interactable -> unit

(**
Ajoute les interactables contenus dans la liste aux Draw et Collision systems
*)
val load : interactable -> unit

(**
Ajoute les interactables dans l'inventaire du player 
*)
val ajoute_inventaire : interactable -> unit 