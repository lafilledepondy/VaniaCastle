(*Constantes techniques*)
let window_width = 800
let window_height = 600
let start_time = Sys.time ()  
let last_time = ref (Sys.time ())
let time_limit = ref (30.0 *. 60.0)
let elasticity = 1.
let gravity = 0.6
let max_fall_speed = 20.

(*Constantes pour le player*)
let jump_power = -30.
let left = -8.
let right = 8.
let coyote = 8
let invincibility = 40

(*Constantes pour les items*)
let inter_default_time = 5.0

(*Constantes pour les ennemis*)
let default_enemy_speed = 4.

(*Textures*)
let fireBallTex = ref Texture.red
let axeTex = ref Texture.red
let crate = ref Texture.yellow
let gameOver = ref Texture.red
let win = ref Texture.green
let title = ref Texture.blue
let cyclotorTex = ref Texture.black
let skeletonTex = ref Texture.yellow
let jonhsonTex = ref Texture.red
let backGround = ref Texture.white
let grass = ref Texture.green
let stone = ref Texture.black
let castle = ref Texture.red
let chalice = ref Texture.red
let manaVial = ref Texture.blue
let antiCross = ref Texture.yellow
let castleCeiling = ref Texture.black
let bossRoomBg = ref Texture.red
let yellowPlatform = ref Texture.yellow
let wallTex = ref Texture.red
let castleGround = ref Texture.black