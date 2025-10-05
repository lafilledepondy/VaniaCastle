open Ecs
(*Vecteur position*)
class position () =
  let r = Component.init Vector.zero in
  object
    method position = r
  end

(*Boîte de collision*)
class box () =
  let r = Component.init Rect.{width = 0; height = 0} in
  object
    method box = r
  end

(*Texture*)
class texture () =
  let r = Component.init (Texture.Color (Gfx.color 0 0 0 255)) in
  object
    method texture = r
  end

(*Tags de base*)
type tag = ..
type tag += No_tag
type tag += Area

(*Tag*)
class tagged () =
  let r = Component.init No_tag in
  object
    method tag = r
  end

(*Vecteur vitesse*)
class velocity () =
  let r = Component.init Vector.zero in
  object
    method velocity = r
  end

(*Masse, nécessaire pour les calculs de collision*)
class mass () =
  let m = Component.init infinity in
  object
    method mass = m
  end

(*Coyote time : Nombre de frames après être arrivé au dessus du vide pendant lesquelles il est encore possible de sauter*)
class coyote_time () =
  let j = Component.init (Cst.coyote) in
  object
    method coyote_time = j
  end

(*Fonction d'intéraction au contact*)
class interaction () =
  let f = Component.init (fun () -> ()) in
  object
    method interaction = f
  end

(*Flottant pour la durée de vie*)
class duration () =
  let d = Component.init infinity in
  object
    method duration = d
  end

(*Flottant pour l'instant de naissance*)
class birth () = 
  let b = Component.init infinity in
  object
    method birth = b
  end

(*Fonction pour supprimer l'objet concerné*)
class delete () =
  let d = Component.init (fun () -> ()) in
  object
    method delete = d
  end

(*Booléen qui indique si l'entité est en train de tomber ou non*)
class falling () =
  let f = Component.init (false) in
  object
    method falling = f
  end

(*Points de vie*)
class health () =
  let h = Component.init (-1) in
  object
    method health = h
  end

(*Points d'attaque*)
class atq () =
  let a = Component.init 0 in
  object
    method atq = a
  end

(* Un carré centré sur l'ennemi. Si le joueur est dedans, l'ennemy se comporte différemment*)
class detection_radius () =
  let r = Component.init 0 in
  object
    method detection_radius = r
  end

(*Rayon d'attaque, centré sur l'ennemy. Si le player y entre, l'ennemy attaque (s'il le peut)*)
class atq_radius () =
  let r = Component.init 0 in
  object
    method atq_radius = r
  end

(*Boîte de dégâts crée par un ennemi lorsqu'il attaque*)
class dmg_box () =
  let d = Component.init (Rect.{width=0; height=0}) in
  object
    method dmg_box = d
  end

(*Fonction qui indique le comportement d'un ennemi*)
class pattern () =
  let f = Component.init (fun () -> ()) in
  object
    method pattern = f
  end

(*
Paire qui indique le temps de rechargement pour pouvoir attaquer à nouveau
La première composante va décroître si nécessaire tandis que la seconde sert à réinitialiser
la première quand elle atteint 0
*)
class cooldown () =
  let c = Component.init (0, 0) in
  object
    method cooldown = c
  end

(*
Paire qui indique le temps de préparation pour pouvoir attaquer
La première composante va décroître si nécessaire tandis que la seconde sert à réinitialiser
la première quand elle atteint 0
*)
class atq_prep () =
  let a = Component.init (0, 0) in
  object
    method atq_prep = a
  end

(*Fonction pour créer un projectile*)
class create_projectile () =
  let c = Component.init (fun () -> ()) in
  object
    method create_projectile = c
  end

(*Indique si l'entité regarde à gauche*)
class left () =
  let l = Component.init false in
  object
    method left = l
  end

(*Indique si l'entité est en train d'attaquer*)
class attacking () =
  let a = Component.init false in
  object
    method attacking = a
  end

(*Vitesse par défaut d'une entité*)
class default_speed () =
  let s = Component.init (Cst.default_enemy_speed) in
  object
    method default_speed = s
  end

(*Frame d'invincibilités après avoir subi un coup*)
class invincibility () =
  let i = Component.init 0 in
  object
    method invincibility = i
  end

(*Priorité de l'entité pour son affichage*)
class priority () =
  let p = Component.init 1 in
  object
    method priority = p
  end

(*Point de mana*)
class mana () =
  let m = Component.init 0 in
  object
    method mana = m
  end

(*Booléen qui indique si l'entité a été touchée par une attaque*)
class hit () =
  let h = Component.init false in
  object
    method hit = h
  end

(*Point de vie maximum*)
class max_health () =
  let h = Component.init 0 in
  object
    method max_health = h
  end

(*Boîte visuelle, permet à une entité d'avoir une texture de taille différente de sa hitbox*)
class visual_box () =
  let b = Component.init Rect.{width=0; height=0} in
  object
    method visual_box = b
  end

(*Décalage visuel, permet à la texture d'une entité de ne pas être affichée aux même coordonnées que sa hitbox*)
class visual_offset () =
  let off = Component.init Vector.zero in
  object
    method visual_offset = off
  end

(*Indique si l'affichage de l'entité doit être effectué avec un décalage*)
class has_offset () =
  let off = Component.init false in
  object
    method has_offset = off
  end

(*Type pour les catégories possibles d'animations*) 
type animationKind = Idle | Walk | Atk | Fall | Jump | Hit
(*Hashtable qui, pour chaque type d'animation, indique sa position dans le tileset de l'objet*)
class frame_set () =
  let f : < get : (animationKind, (int * int)) Hashtbl.t ; 
  set : (animationKind, (int * int)) Hashtbl.t -> unit > = Component.init (Hashtbl.create 5) in
  object
    method frame_set = f
  end

(*
Coordonnées du sprite courant dans le tileset, sous la forme (x, y, maxX)
où x est l'abscisse, y l'ordonnée, et maxX la valeur maximale que peut prendre
x pour cette ordonnée
*)
class animation_index () =
  let i = Component.init (0, 0, 0) in
  object
    method animation_index = i
  end

(*Animation qu'est en train d'effectuer l'entité*)
class current_animation () =
  let a = Component.init Idle in
  object
    method current_animation = a
  end

(*Animation qu'était en train d'effectuer l'entité lors de la dernière éxécution de l'Animation_system*)
class previous_animation () =
  let a = Component.init Idle in
  object
    method previous_animation = a
  end

(*Largeur du tileset de l'entité. Nécessaire pour faire la distinction entre les textures selon la direction pointée par l'entité*)
class file_width () =
  let f = Component.init 0 in
  object
    method file_width = f
  end

(*Fonction pour décharger l'entité*)
class unload () =
let u = Component.init (fun () -> ()) in
object
  method unload = u
end

(*Fonction pour charger l'entité*)
class load () =
let u = Component.init (fun () -> ()) in
object
  method load = u
end

(*Fonction pour ajouter l'entité à un inventaire*)
class add_inventory () =
let a = Component.init (fun () -> ()) in
object
  method add_inventory = a
end

(** Interfaces : ici on liste simplement les types des classes dont on hérite
    si deux classes définissent les mêmes méthodes, celles de la classe écrite
    après sont utilisées (héritage multiple).
*)

(*Type des objets pouvant entrer en collision les uns avec les autres*)
class type collidable =
  object
    inherit Entity.t
    inherit position
    inherit box
    inherit tagged
    inherit mass
    inherit velocity
    inherit atq (*Il était prévu que des plateformes puissent infliger des dégâts*)
  end

(*Type des objets affichables*)
class type drawable =
  object
    inherit Entity.t
    inherit position
    inherit box
    inherit visual_box
    inherit visual_offset
    inherit has_offset
    inherit texture
    inherit priority
    inherit animation_index
    inherit file_width
    inherit left
  end

(*Type des objets pouvant se mouvoir*)
class type movable =
  object
    inherit Entity.t
    inherit position
    inherit velocity
    inherit falling
    inherit tagged
  end

(*Type des objets ayant une durée de vie*)
class type expirable =
  object
    inherit Entity.t
    inherit birth
    inherit duration
    inherit delete
  end

(*Type des entités pouvant attaquer sans input*)
class type fighter =
  object
    inherit Entity.t
    inherit tagged
    inherit box
    inherit position
    inherit velocity
    inherit atq
    inherit atq_radius
    inherit cooldown
    inherit atq_prep
    inherit create_projectile
    inherit left
    inherit attacking
    inherit default_speed
  end

(*Type des entités mortelles*)
class type mortal =
  object
    inherit Entity.t
    inherit delete
    inherit health
  end

(*Type des entités animées*)
class type animated =
  object
    inherit Entity.t
    inherit animation_index
    inherit frame_set
    inherit current_animation
    inherit previous_animation
  end

(** Entités :
    Ici, dans inherit, on appelle les constructeurs pour qu'ils initialisent
    leur partie de l'objet, d'où la présence de l'argument ()
*)

(*Classe des ennemis*)
class enemy name =
  object
    inherit Entity.t ~name ()
    inherit position ()
    inherit box ()
    inherit tagged ()
    inherit texture ()
    inherit velocity ()
    inherit falling ()
    inherit health ()
    inherit mass ()
    inherit atq ()
    inherit detection_radius ()
    inherit atq_radius ()
    inherit pattern ()
    inherit dmg_box ()
    inherit cooldown ()
    inherit atq_prep ()
    inherit create_projectile ()
    inherit left ()
    inherit attacking ()
    inherit default_speed ()
    inherit priority ()
    inherit hit ()
    inherit delete ()
    inherit max_health ()
    inherit visual_offset ()
    inherit visual_box ()
    inherit has_offset ()
    inherit animation_index ()
    inherit file_width ()
    inherit frame_set ()
    inherit current_animation ()
    inherit previous_animation ()
  end

(*Liste d'enemy correspondant aux enemy touchés par une attaque de mêlée*)
class hitted () =
  let h : < get : enemy list; set : enemy list -> unit > = Component.init [] in
  object
    method hitted = h
  end

(*Classe des projectiles*)
class projectile () =
  object
    inherit Entity.t ()
    inherit position ()
    inherit box ()
    inherit tagged ()
    inherit texture ()
    inherit velocity ()
    inherit atq ()
    inherit birth ()
    inherit duration ()
    inherit delete ()
    inherit mass ()
    inherit falling ()
    inherit priority ()
    inherit hitted ()
    inherit visual_offset ()
    inherit visual_box ()
    inherit has_offset ()
    inherit animation_index ()
    inherit file_width ()
    inherit left ()
    inherit frame_set ()
    inherit current_animation ()
    inherit previous_animation ()
  end

(*Classe d'une boîte*)
class contactBox () =
  object
    inherit Entity.t ()
    inherit position ()
    inherit box ()
    inherit tagged ()
    inherit texture ()
    inherit mass ()
    inherit velocity ()
    inherit atq ()
    inherit priority ()
    inherit falling ()
    inherit visual_offset ()
    inherit visual_box ()
    inherit has_offset ()
    inherit animation_index ()
    inherit file_width ()
    inherit left ()
  end

(*Classe d'un item*)
class interactable name =
  object
    inherit Entity.t ~name ()
    inherit position ()
    inherit box ()
    inherit tagged ()
    inherit texture ()
    inherit interaction ()
    inherit duration ()
    inherit birth ()
    inherit delete ()
    inherit mass ()
    inherit velocity ()
    inherit unload ()
    inherit add_inventory ()
    inherit atq ()
    inherit priority ()
    inherit visual_offset ()
    inherit visual_box ()
    inherit has_offset ()
    inherit animation_index ()
    inherit file_width ()
    inherit left ()
  end

(*
Table de hash pour l'inventaire.
L'idée était la suivante : un item possède un nom et une utilité.
Le player peut posséder n >= 0 itérations d'un item, mais on a juste besoin
de savoir comment l'item s'appelle, la valeur de n, et son utilité
*)
class inventory () =
  let i : < get : (string, (int * (unit->unit))) Hashtbl.t ; 
  set : (string, (int * (unit->unit))) Hashtbl.t -> unit > = Component.init (Hashtbl.create 20) in
  object
    method inventory = i
  end

(*Classe du player*)
class player name =
  object
    inherit Entity.t ~name ()
    inherit position ()
    inherit box ()
    inherit tagged ()
    inherit texture ()
    inherit velocity ()
    inherit coyote_time ()
    inherit falling ()
    inherit health ()
    inherit inventory ()
    inherit mass ()
    inherit invincibility ()
    inherit priority ()
    inherit cooldown ()
    inherit atq ()
    inherit dmg_box ()
    inherit mana ()
    inherit left ()
    inherit visual_offset ()
    inherit visual_box ()
    inherit has_offset ()
    inherit frame_set ()
    inherit animation_index ()
    inherit current_animation ()
    inherit previous_animation ()
    inherit file_width ()
  end

(*Liste d'items pour une area*)
class elements () =
  let elts : < get : interactable list; set : interactable list -> unit > = Component.init [] in
  object
    method elements = elts
  end

(*Liste de boîtes pour une area*)
class walls () =
let w : < get : contactBox list; set : contactBox list -> unit > = Component.init [] in
object
  method walls = w
end

(*Liste d'enemy pour une area*)
class enemies () =
let e : < get : enemy list; set : enemy list -> unit > = Component.init [] in
object
  method enemies = e
end

(*La classe qui représente une zone*)
class area () =
  object
    inherit Entity.t ()
    inherit position ()
    inherit elements ()
    inherit box ()
    inherit walls ()
    inherit tagged ()
    inherit enemies ()
    inherit load ()
    inherit unload ()
  end

(*Les tags des différentes boîtes*)
type tag += 
  | Platform of contactBox
  | Pretty of contactBox
  | Block of contactBox (*Inutilisé*)
  | Warp of contactBox*area*(int -> int)*(int -> int)
  | Click of contactBox*(unit->unit) (*Inutilisé*)

(*Les classes de combat pour les ennemis et le tag ennemy*)
type combatClass = Melee | Shooter
type tag += Enemy of enemy * combatClass

(*Les tag des items*)
type tag += 
    | OtherItem of interactable
    | CollectableItem of interactable

(*Le tag du player*)
type tag += Player

(*Les tags des projectiles*)
type tag += Projectile of projectile | DmgZone of projectile
type tag += Attack of projectile | Magic of projectile