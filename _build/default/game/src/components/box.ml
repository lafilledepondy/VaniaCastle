open Component_defs
open System_defs

(*Remplacer tout par seulement platform ?*)
type tag += 
  | Ceiling of contactBox 
  | Floor of contactBox 
  | Wall of contactBox 
  | Platform of contactBox 
  | Warp of contactBox*area*(int -> int)*(int -> int)
  | Click of contactBox*(unit -> unit)

type boxCat = 
  | Ceiling 
  | Floor 
  | Wall 
  | Platform 
  | Warp
  | Click

(*Pour créer des boîtes de collision*)
let create (x, y, width, height, tex, cat) =
  let e = new contactBox () in
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width; height};
  e#texture#set tex;
  e#tag#set (match cat with
  | Ceiling -> Ceiling(e)
  | Floor -> Floor(e)
  | Wall -> Wall(e)
  | Platform -> Platform(e)
  | Warp -> failwith "Please use the correct create function for Warpzones"
  | Click -> failwith "Please use the correct create function for Click boxes");
  (*Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));*)
  e

(*Pour créer des warpzones*)
let createWarp (x, y, width, height, tex, (a, x_offset, y_offset)) =
    let e = new contactBox () in
    e#position#set Vector.{x = float x; y = float y};
    e#box#set Rect.{width; height};
    e#texture#set tex;
    e#tag#set (Warp(e, a, x_offset, y_offset));
    (*Draw_system.(register (e :> t));
    Collision_system.(register (e :> t));*)
    e

let createClick (x, y, width, height, tex, clic) =
  let e = new contactBox () in
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width; height};
  e#texture#set tex;
  e#tag#set (Click(e, clic));
  (*Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));*)
  e

let move_box b v =
  b#position#set Vector.{x=b#position#get.x+.v.x; y=b#position#get.y+.v.y}

let t = Texture.transparent
let r = Texture.red
let default () = (*À modifier (plus tard) : Les murs seront gérés de manière plus dynamique*)
    List.map create
      Cst.[ 
        (hwall1_x, hwall1_y, hwall_width, hwall_height, t, Ceiling);
        (hwall2_x, hwall2_y, hwall_width, hwall_height, t, Floor);
        (vwall1_x, vwall1_y, vwall_width, vwall_height, t, Wall);
        (vwall2_x, vwall2_y, vwall_width, vwall_height, t, Wall);
        (400, 400, 50, 50, r, Platform);
        (500, 300, 50, 50, r, Platform)
      ]


let wallsZ1 () =
  List.map create [(0, 499, 6000, 100, t, Platform);
                  (5600, -101, 800, 700, t, Platform);
                  (6400, -701, 800, 1300, t, Platform);]

let testBoxes () =
  List.map create [(0, 544, 800, 56, t, Floor);
                  (*(0, 0, 10, 543, t, Wall);
                  (790, 0, 10, 415, t, Wall);*)
                  (48, 144, 47, 47, t, Platform);
                  (320, 256, 47, 47, t, Platform);
                  (272, 352, 47, 47, t, Platform);
                  (224, 448, 47, 47, t, Platform);
                  (144, 192, 127, 47, t, Platform);
                  (416, 192, 143, 47, t, Platform);
                  (560, 144, 191, 47, t, Platform);
                  (672, 480, 63, 63, t, Platform);
                  (736, 416, 63, 63, t, Platform);]

let testBoxesMirr () =
  List.map create [(0, 544, 800, 56, t, Floor);
                  (*(0, 0, 10, 543, t, Wall);
                  (790, 0, 10, 415, t, Wall);*)
                  (704, 144, 47, 47, t, Platform);
                  (432, 256, 47, 47, t, Platform);
                  (480, 352, 47, 47, t, Platform);
                  (528, 448, 47, 47, t, Platform);
                  (528, 192, 127, 47, t, Platform);
                  (240, 192, 143, 47, t, Platform);
                  (48, 144, 191, 47, t, Platform);
                  (64, 480, 63, 63, t, Platform);
                  (0, 416, 63, 63, t, Platform);]