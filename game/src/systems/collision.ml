open Ecs
open Component_defs

type t = collidable

let init _ = ()

let rec iter_pairs f s =
  match s () with
    Seq.Nil -> ()
  | Seq.Cons(e, s') ->
    Seq.iter (fun e' -> f e e') s';
    iter_pairs f s'


(*
Réinitialise le booléen de chute et la vitesse verticale d'un player
ou d'un ennemi lors du contact avec un sol (partie supérieur d'une
plateforme)
*)
let reset_if_ground (e1 : t) (e2 : t) =
  match e1#tag#get, e2#tag#get with
  | Player, Platform(plat) | Platform(plat), Player ->
    let p = (Global.get ()).player in
    let px, py = p#position#get.Vector.x, p#position#get.Vector.y in
    let platx, platy = plat#position#get.Vector.x, plat#position#get.Vector.y in
    let w = plat#box#get.width in
    let wp = p#box#get.width in
    (*Le décalage de 3 pixels donne un peu de flexibilité*)
    if py <= platy && px >= platx -. float wp +. 3. && px <= platx +. float w -. 3. then
      (p#velocity#set Vector.{x=p#velocity#get.x; y=0.};
      p#falling#set false;
      p#coyote_time#set Cst.coyote;)
  | Enemy(e, _), Platform(plat) | Platform(plat), Enemy(e, _) ->
    let ex, ey = e#position#get.Vector.x, e#position#get.Vector.y in
    let platx, platy = plat#position#get.Vector.x, plat#position#get.Vector.y in
    let w = plat#box#get.width in
    let we = e#box#get.width in
    (*Le décalage de 3 pixels donne un peu de flexibilité*)
    if ey <= platy && ex >= platx -. float we +. 3. && ex <= platx +. float w -. 3. then
      (e#velocity#set Vector.{x=e#velocity#get.x; y=0.};
      e#falling#set false;)
  | _ -> ()

(*
Fais en sorte qu'un ennemi fasse demi-tour s'il rencontre le bord d'une plateforme
ou un mur ou une warpzone
*)
let turnaround (e1 : t) (e2 : t) penetration =
  match e1#tag#get, e2#tag#get with
  | Enemy(e, _), Platform(plat) | Platform(plat), Enemy(e, _) ->
    let ex, ey = e#position#get.Vector.x, e#position#get.Vector.y in
    let platx, platy = plat#position#get.Vector.x, plat#position#get.Vector.y in
    let w = plat#box#get.width in
    let we = e#box#get.width in
    if (ey <= platy && ex >= platx +. float w -. float we) || penetration.Vector.x < 0.0 then
      (e#velocity#set Vector.{x= -. Cst.default_enemy_speed; y=e#velocity#get.y};
      e#left#set true);
    if (ey <= platy && ex <= platx) || penetration.Vector.x > 0.0 then
      begin
      e#velocity#set Vector.{x = Cst.default_enemy_speed; y=e#velocity#get.y};
      e#left#set false
      end
  | _ -> ()



(*Algo de collision du TP3*)
let default_collision (e1:t) (e2:t) =
  let m1 = e1#mass#get in
  let m2 = e2#mass#get in
  if Float.is_finite m1 || Float.is_finite m2 then begin
    let p1 = e1#position#get in
    let b1 = e1#box#get in
    let p2 = e2#position#get in
    let b2 = e2#box#get in
    let pdiff, rdiff = Rect.mdiff p2 b2 p1 b1 in
    if Rect.has_origin pdiff rdiff then begin
      let v1 = e1#velocity#get in
      let v2 = e2#velocity#get in
      let pn = Rect.penetration_vector pdiff rdiff in
      let nv1 = Vector.norm v1 in
      let nv2 = Vector.norm v2 in
      let sv = nv1 +. nv2 in
      let n1, n2 =
        if Float.is_infinite m1 then 0.0, 1.0
        else if Float.is_infinite m2 then 1.0, 0.0
        else nv1 /. sv, nv2 /. sv
      in
      let p1 = Vector.add p1 (Vector.mult n1 pn) in
      let p2 = Vector.sub p2 (Vector.mult n2 pn) in
      e1#position#set p1;
      e2#position#set p2;
      let n = Vector.normalize pn in
      let vdiff = Vector.sub v1 v2 in
      let e = 1.0 in
      let inv_mass = (1.0 /. m1) +. (1.0 /. m2) in
      let j = Vector.dot (Vector.mult (-.(1.0 +. e)/.inv_mass) vdiff) n in
      let nv1 = Vector.add v1 (Vector.mult (j/.m1) n) in
      let nv2 = Vector.sub v2 (Vector.mult (j/.m2) n) in
      e1#velocity#set nv1;
      e2#velocity#set nv2;
      reset_if_ground e1 e2;
      turnaround e1 e2 pn;
    end
  end



let update _ el =
  el
  |> iter_pairs (fun (e1:t) (e2:t) ->
    if Rect.intersect e1#position#get e1#box#get e2#position#get e2#box#get then
      match e1#tag#get, e2#tag#get with
      (*Code sommaire et buggué pour pousser une caisse*)
      | Player, Block _ | Block _, Player | Block _, Block _ ->
        let p = (Global.get ()).player in
        let m = p#mass#get in
        p#mass#set infinity;
        default_collision e1 e2;
        p#mass#set m
      (*Une plateforme arrête une caisse*)
      | Block b, Platform _ | Platform _, Block b | Block b, Warp _ | Warp _, Block b ->
        default_collision e1 e2;
        b#velocity#set Vector.zero
      (*Le joueur est téléporté s'il touche une warpzone*)
      | Player, Warp(b, dest, xOff, yOff) | Warp(b, dest, xOff, yOff), Player ->
          let g = Global.get () in
          let p = g.player in
          let orr = g.area in
          (*Il faut charger/décharger dans cet ordre sinon ça plante*)
          dest#load#get ();
          orr#unload#get ();
          g.area <- dest;
          (*Nouvelles positions calculées grâce aux offsets de la warpzone*)
          p#position#set Vector.{x=float(xOff (int_of_float p#position#get.x)); y=float(yOff (int_of_float p#position#get.y))}
      (*On effectue l'interaction quand on touche l'interactable*)
      | Player, OtherItem(i) | OtherItem(i), Player ->
        i#interaction#get ();
        i#unload#get ()
      (*On effectue l'interaction puis on ajoute à l'inventaire quand on touche un collectible*)
      | Player, CollectableItem(i) | CollectableItem(i), Player ->
        i#interaction#get ();
        i#add_inventory#get ();
        let inv = (Global.get ()).player#inventory#get in
        Hashtbl.iter (fun n (q, _) -> Gfx.debug "nom : %s; qté : %d\n%!" n q) inv
      (*Un enemy qui touche un warp fait demi tour*)
      | Enemy(e, _), Warp(_, _, _, _) | Warp(_, _, _, _), Enemy(e, _) ->
        e#velocity#set Vector.{x=(-.e#velocity#get.x); y=e#velocity#get.y};
        default_collision e1 e2
      | Enemy(e, _), Platform(p) | Platform(p), Enemy(e, _) ->
        default_collision e1 e2
      (*Aucune interaction entre player et enemy*)
      | Enemy(e, _), Player | Player, Enemy(e, _) ->
        ()
      (*Player qui se fait taper*)
      | Projectile(pr), Player | Player, Projectile(pr) | DmgZone(pr), Player | Player, DmgZone(pr) ->
        let p = (Global.get ()).player in
        if p#invincibility#get = 0 then (*Pas de dégâts pendant les frames d'invincibilité*)
          (p#health#set (p#health#get - pr#atq#get);
          p#invincibility#set Cst.invincibility;
          let px = p#position#get.Vector.x in
          let pw = float (p#box#get.Rect.width/2) in
          let prx = pr#position#get.Vector.x in
          let x = if px +. pw < prx then -.2. else 2. in
          p#velocity#set Vector.{x; y=0.});
        pr#delete#get ()
      (*Une magie touche un ennemy*)
      | Magic m, Enemy (e, _)
      | Enemy (e, _), Magic m ->
        (Global.get()).current_target <- Some e;
        m#delete#get (); (*Une magie touche au plus un et un seul enemy*)
        if not(e#hit#get) then e#health#set (e#health#get - m#atq#get)
      (*Une attaque touche un ennemy*)
      | Attack a, Enemy(e, _)
      | Enemy(e, _), Attack a ->
        (Global.get()).current_target <- Some e;
        if not(e#hit#get) then
          begin
          e#health#set (e#health#get - a#atq#get);
          a#hitted#set (e::a#hitted#get);
          e#hit#set true
          end
      (*Un projectile touche une plateforme quelconque*)
      | Projectile pr, Warp _
      | Warp _, Projectile pr
      | Projectile pr, Platform _
      | Platform _, Projectile pr
      | Magic pr, Warp _
      | Warp _, Magic pr
      | Magic pr, Platform _
      | Platform _, Magic pr ->
        pr#delete#get ()
      (*Un projectile en touche un autre*)
      | Projectile e1, Magic e2
      | Magic e1, Projectile e2
      | Projectile e1, Attack e2
      | Attack e1, Projectile e2
      | Magic e1, DmgZone e2
      | DmgZone e1, Magic e2
      | Attack e1, DmgZone e2
      | DmgZone e2, Attack e1 ->
        e1#delete#get ();
        e2#delete#get ()
      | Block _, _ | _, Block _
      | Projectile _, _ | _, Projectile _
      | DmgZone _, _ | _, DmgZone _
      | Magic _, _ | _, Magic _
      | Attack _, _ | _, Attack _
      | Enemy _, Enemy _
      | Pretty _, _ | _, Pretty _
      | OtherItem _, _ | _, OtherItem _
      | CollectableItem _, _ | _, CollectableItem _ -> ()
      | _, _ -> default_collision e1 e2
    )
