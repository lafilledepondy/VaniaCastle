type t =
    Image of Gfx.surface
  | Color of Gfx.color

let black = Color (Gfx.color 0 0 0 255)
let white = Color (Gfx.color 255 255 255 255)
let red = Color (Gfx.color 255 0 0 255)
let green = Color (Gfx.color 0 255 0 255)
let blue = Color (Gfx.color 0 0 255 255)

let yellow = Color (Gfx.color 255 255 0 255)
let transparent = Color (Gfx.color 0 0 0 0)

let draw ctx dst drawPos box extractPos src =
  let dx = int_of_float drawPos.Vector.x in
  let dy = int_of_float drawPos.Vector.y in
  let Rect.{width=dw;height=dh} = box in
  let sx = int_of_float extractPos.Vector.x in
  let sy = int_of_float extractPos.Vector.y in
  let Rect.{width=sw;height=sh} = box in
  match src with
    Image img ->
      Gfx.blit_full ctx dst img sx sy sw sh dx dy dw dh;
      Gfx.commit ctx
  | Color c ->
      Gfx.set_color ctx c;
      Gfx.fill_rect ctx dst dx dy dw dh;
      Gfx.commit ctx