open Component_defs

(**
Type spécial pour identifier les différentes catégories de projectiles
*)
type projCat = Hit | Throw | Attack | Magic

(**
projectile (x, y, tex, width, height, atq, time, speedX, speedY, cat, fall)
Crée le un projectile et le renvoie avec :
- x son abscisse
- y son ordonnée
- tex sa texture
- width sa largeur
- height sa hauteur
- atq le nombre de dégâts qu'il inflige
- time sa durée de vie
- speedX sa vitesse en abscisse
- speedY sa vitesse en ordonnée
- cat la catégorie de projectile dont il s'agit
- fall un booléen qui indique si le projectile subit la gravité ou non
*)
val projectile : int * int * Texture.t * int * int * int * float * float * float * projCat * bool -> projectile