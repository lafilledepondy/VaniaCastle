(*Pas de mli; je demandrais s'il en faut un et si oui comment le faire correctement*)

open Ecs
class position () =
  let r = Component.init Vector.zero in
  object
    method position = r
  end

class box () =
  let r = Component.init Rect.{width = 0; height = 0} in
  object
    method box = r
  end

class texture () =
  let r = Component.init (Texture.Color (Gfx.color 0 0 0 255)) in
  object
    method texture = r
  end

type tag = ..
type tag += No_tag

class tagged () =
  let r = Component.init No_tag in
  object
    method tag = r
  end

class resolver () =
  let r = Component.init (fun (_ : Vector.t) (_ : tagged) -> ()) in
  object
    method resolve = r
  end

class velocity () =
  let r = Component.init Vector.zero in
  object
    method velocity = r
  end

class coyote_time () =
  let j = Component.init (Cst.coyote) in
  object
    method coyote_time = j
  end

class interaction () =
  let f = Component.init (fun () -> ()) in
  object
    method interaction = f
  end

class duration () =
  let d = Component.init infinity in
  object
    method duration = d
  end

class birth () = 
  let b = Component.init infinity in
  object
    method birth = b
  end

class delete () =
  let d = Component.init (fun () -> ()) in
  object
    method delete = d
  end

class falling () =
  let f = Component.init (false) in
  object
    method falling = f
  end

(*Sert exclusivement à faire en sorte que la fonction de mouvement se comporte différemment pour l'entité joueur.
C'est (selon moi) nécessaire pour que la caméra suive le joueur*)
class is_player () =
  let ip = Component.init (false) in
  object
    method is_player = ip
  end

class health () =
  let h = Component.init (-1) in
  object
    method health = h
  end

(** Interfaces : ici on liste simplement les types des classes dont on hérite
    si deux classes définissent les mêmes méthodes, celles de la classe écrite
    après sont utilisées (héritage multiple).
*)

class type collidable =
  object
    inherit Entity.t
    inherit position
    inherit box
    inherit tagged
    inherit resolver
  end

class type drawable =
  object
    inherit Entity.t
    inherit position
    inherit box
    inherit texture
  end

class type movable =
  object
    inherit Entity.t
    inherit position
    inherit velocity
    inherit falling
    inherit is_player
  end

class type expirable =
  object
    inherit Entity.t
    inherit birth
    inherit duration
    inherit delete
  end

(** Entités :
    Ici, dans inherit, on appelle les constructeurs pour qu'ils initialisent
    leur partie de l'objet, d'où la présence de l'argument ()
*)
class enemy name =
  object
    inherit Entity.t ~name ()
    inherit position ()
    inherit box ()
    inherit tagged ()
    inherit texture ()
    inherit resolver ()
    inherit velocity ()
    inherit falling ()
    inherit is_player ()
    inherit health ()
  end

class ball () =
  object
    inherit Entity.t ()
    inherit position ()
    inherit box ()
    inherit tagged ()
    inherit texture ()
    inherit resolver ()
    inherit velocity ()
    inherit falling ()
    inherit is_player ()
  end

class contactBox () =
  object
    inherit Entity.t ()
    inherit position ()
    inherit box ()
    inherit tagged ()
    inherit texture ()
    inherit resolver ()
  end

class interactable name =
  object
    inherit Entity.t ~name ()
    inherit position ()
    inherit box ()
    inherit tagged ()
    inherit texture ()
    inherit resolver ()
    inherit interaction ()
    inherit duration ()
    inherit birth ()
    inherit delete ()
  end

class inventory () =
  let i : < get : (string, (int * (unit->unit))) Hashtbl.t ; 
  set : (string, (int * (unit->unit))) Hashtbl.t -> unit > = Component.init (Hashtbl.create 20) in
  object
    method inventory = i
  end

class player name =
  object
    inherit Entity.t ~name ()
    inherit position ()
    inherit box ()
    inherit tagged ()
    inherit texture ()
    inherit resolver ()
    inherit velocity ()
    inherit coyote_time ()
    inherit falling ()
    inherit is_player ()
    inherit health ()
    inherit inventory ()
  end

class elements () =
  let elts : < get : interactable list; set : interactable list -> unit > = Component.init [] in
  object
    method elements = elts
  end

class walls () =
let w : < get : contactBox list; set : contactBox list -> unit > = Component.init [] in
object
  method walls = w
end

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
    (*meme chose pour ennemis*)
    inherit texture ()
    inherit walls ()
    inherit tagged ()
    inherit resolver ()
    inherit enemies ()
  end

(*Ajouter une classe pour les pentes OU modifier box pour pouvoir représenter des triangles*)