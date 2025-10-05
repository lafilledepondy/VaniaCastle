open Component_defs

(**
Type spécial pour identifier la catégorie à laquelle appartient un interactable 
*)
type interType = 
    | OtherItem
    | CollectableItem

(**
interactable (name, x, y, txt, width, height, action, time, inter)
Crée un interactable avec les paramètres suivants :
- name son nom
- x son abscisse
- y son ordonnée
- txt sa texture
- width la largeur de sa hitbox
- height la hauteur de sa hitbox
- action l'action a effectuer lorsque l'on intéragit avec
- time sa durée de vie
- inter le type d'interactable dont il s'agit
*)
val interactable : string * int * int * Texture.t * int * int * (unit -> unit) * float * interType -> interactable 

(**
Ajoute les interactables contenus dans la liste aux Draw et Collision systems
*)
val load : interactable -> unit

(**
Crée un calice de soin aux coordonnées x y et le renvoie
*)
val healingChalice : int -> int -> interactable

(**
Crée une orbe de mana aux coordonnées x y et la renvoie
*)
val manaVial : int -> int -> interactable

(**
Crée une anti-croix aux coordonnées x y et la renvoie
*)
val antiCross : int -> int -> interactable