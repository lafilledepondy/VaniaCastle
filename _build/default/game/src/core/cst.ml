(*Pas besoin de mli ici*)


let window_width = 800
let window_height = 600

(*deviendront inutiles*)
let paddle_width = 24
let paddle_height = 128

let paddle1_x = 64 + paddle_width / 2
let paddle1_y = window_height / 2 - paddle_height / 2

let paddle2_x = window_width - paddle1_x - paddle_width
let paddle2_y = paddle1_y
let paddle_color = Texture.blue

let paddle_v_up = Vector.{ x = 0.0; y = -5.0 }
let paddle_v_down = Vector.sub Vector.zero paddle_v_up

let ball_size = 24
let ball_color = Texture.red

let ball_v_offset = window_height / 2 - ball_size / 2
let ball_left_x = 128 + ball_size / 2
let ball_right_x = window_width - ball_left_x - ball_size
(**)
let wall_thickness = 32

let hwall_width = window_width
let hwall_height = wall_thickness
let hwall1_x = 0
let hwall1_y = 0
let hwall2_x = 0
let hwall2_y = window_height -  wall_thickness
let hwall_color = Texture.green

let vwall_width = wall_thickness
let vwall_height = window_height - 2 * wall_thickness
let vwall1_x = 0
let vwall1_y = wall_thickness
let vwall2_x = window_width - wall_thickness
let vwall2_y = vwall1_y
let vwall_color = Texture.yellow

let font_name = if Gfx.backend = "js" then "monospace" else "resources/images/monospace.ttf"
let font_color = Gfx.color 0 0 0 255


(*Nouvelles constantes*)
let jump_power = -30.

let left = -8.
let right = 8.
let gravity = 1.
let max_fall_speed = 20.

let ground = window_height - wall_thickness

let height = paddle_height

let coyote = 8

let start_time = Sys.time ()  

let last_time = ref (Sys.time ())


let time_limit = 30.0 *. 60.0 (* 30mins in secs*)
let inter_default_time = 5.0 (*<= en sec for testing !*)

let default_enemy_speed = 4.