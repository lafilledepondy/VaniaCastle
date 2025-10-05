open Component_defs

(**
Type spécial pour identifier la catégorie à laquelle appartient une boîte
*)
type boxCat = 
  | Platform
  | Warp
  | Click
  | Pretty
  | Block

(**
create(x, y, width, height, tex, cat)
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
createWarp(x, y, width, height, tex, (a, x_offset, y_offset))
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
Crée les boîtes de la première zone
*)
val boxesFirstArea : unit -> contactBox list

(**
Crée les boîtes de la seconde zone
*)
val boxesSecondArea : unit -> contactBox list

(**
Crée les boîtes de la salle de boss
*)
val boxesBossRoom : unit -> contactBox list

(**
Crée la boîte correspondant à l'écran de fin de partie
*)
val gameOverScreen : unit -> contactBox

(**
Crée la boîte correspondant à l'écran de victoire
*)
val winningScreen : unit -> contactBox

(**
Crée la boîte correspondant à l'écran de démarrage
*)
val titleScreen : unit -> contactBox


(**
Barre de vie du player
*)
val healthBar : contactBox

(**
Barre de mana du player
*)
val manaBar : contactBox

(**
Barre de vie de l'ennemi courant (dernier ennemi frappé)
*)
val enemyHealthBar : contactBox

(**
Met à jour la barre de vie du joueur
*)
val update_health_bar : unit -> unit

(**
Met à jour la barre de mana du joueur
*)
val update_mana_bar : unit -> unit

(**
Met à jour la barre de vie de l'ennemi courant (dernier ennemi frappé)
*)
val update_enemy_health_bar : unit -> unit