type t = { x : float; y : float }

let add a b = { x = a.x +. b.x; y = a.y +. b.y }
let sub a b = { x = a.x -. b.x; y = a.y -. b.y }

let mult k a = { x = k*. a.x; y = k*. a.y }

let dot a b =  a.x *. b.x +. a.y *. b.y
let norm a = dot a a

let normalize a =
  let scal = norm a in
  if scal = 0. then a
  else
  {x = a.x /. scal; y = a.y/. scal}

let pp fmt a = Format.fprintf fmt "(%f, %f)" a.x a.y

let debug v = Gfx.debug "(%f, %f)\n%!" v.x v.y

let zero = { x = 0.0; y = 0.0 }
let is_zero v = v.x = 0.0 && v.y = 0.0