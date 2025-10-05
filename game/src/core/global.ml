open Component_defs


type t = {
  window : Gfx.window;                   (*Fenêtre de jeu*)
  ctx : Gfx.context;                     (*Contexte Gfx pour l'affichage*)
  player : player;                       (*Joueur*)
  mutable started : bool;                (*Booléen qui indique si le jeu a commencé*)
  mutable screen : contactBox option;    (*Option qui contient, si elle existe, une boîte a afficher sur tout l'écran*)
  mutable waiting : bool;                (*Booléen qui indique si le jeu est en pause*)
  mutable dead : bool;                   (*Booléen qui indique si le joueur est mort*)
  mutable area : area;                   (*Zone courante*)
  mutable projectiles : projectile list; (*Liste des projectiles actuellement lancés*)
  mutable current_target : enemy option; (*Enemy courant (dernier ennemi frappé)*)
  boss : enemy;                          (*Le boss (Cyclotor L'affreux)*)
  healthBar : contactBox;                (*La barre de vie du joueur*)
  enemyHealthBar : contactBox;           (*La barre de vie de l'ennemi courant*)
  manaBar : contactBox;                  (*La barre de mana du joueur*)
  deb : float;                           (*L'instant de début*)
}

let state = ref None

let get () : t =
  match !state with
    None -> failwith "Uninitialized global state"
  | Some s -> s

let removeProjectile p =
  let g = get() in
  let lp = g.projectiles in
  let rec remove l rem =
    match l with
    | [] -> rem
    | pr::ll ->
      if p = pr then
        ll@rem
      else
        remove ll (pr::rem)
  in
  g.projectiles <- remove lp []

let set s = state := Some s