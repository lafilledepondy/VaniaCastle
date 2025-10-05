type t = {width : int; height : int}

(**
Soustraction de Minkowski entre rectangle r1 au coordonnées
v1 et rectangle r2 aux coordonnées v2
*)
val mdiff : Vector.t -> t -> Vector.t -> t -> (Vector.t * t)

(**
Renvoie le vecteur ayant la norme la plus petite
*)
val min_norm : Vector.t -> Vector.t -> Vector.t

(**
has origin r v Vérifie si le rectangle r aux coordonnées v contient l'origine
*)
val has_origin : Vector.t -> t -> bool

(**
intersect v1 r1 v2 r2
Vrai si le rectangle r1 aux coordonées v1 intersecte le rectangle r2 aux coordonnées v2
*)
val intersect : Vector.t -> t -> Vector.t -> t -> bool

(**
Vérifie si un flottant est nul
*)
val is_zero : float -> bool

(**
Given the Mdiff of two boxes, if they intersect,
returns the penetration vector, that is the smallest
vector one should move the boxes away from to separate them:


.------------------
|                 |
|    --------     |   -
|    |      |     |   |  <- penetration vector can separate the boxes
|----+------+------   v
     |      |
     |      |
     .-------

*)
val penetration_vector : Vector.t -> t -> Vector.t

(**
Returns None if the two boxes don't intersect and Some v
if they do, where v is the rebound to apply, assuming one
of the object is fixed.
*)
val rebound : Vector.t -> t -> Vector.t -> t -> Vector.t option