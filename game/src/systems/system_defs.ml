open Ecs

module Collision_system = System.Make(Collision)

module Draw_system = System.Make(Draw)

module Move_system = System.Make(Move)

module Time_system = System.Make(TimeSystem)

module Fight_system = System.Make(Fight)

module Death_system = System.Make(Death)

module Animation_system = System.Make(Animation)

module Gravity_system = System.Make(Gravity)