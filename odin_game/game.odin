package main

import rl "vendor:raylib"
import la "core:math/linalg"
import "core:strings"
import "core:math"

WIDTH :: 1200
HEIGHT :: 900

player :: struct {
    pos: rl.Vector2,
    width: int,
    height: int,
    color: rl.Color,
}

Enemy :: struct {
    pos: rl.Vector2,
    vel: rl.Vector2,
    health: int,
    texture: rl.Texture2D
}

Button :: struct {
    rect: rl.Rectangle,
    label: string,
}

flower_type :: enum {
    orchid
}

Flower :: struct {
    pos: rl.Vector2,
    type: flower_type,
    rotation: f32,
    texture: rl.Texture2D
}

FlowerArray: [dynamic]Flower
EnemyArray: [dynamic]Enemy

draw_button :: proc(b: Button) -> bool {
    mouse := rl.GetMousePosition()
    hover := rl.CheckCollisionPointRec(mouse, b.rect)
    clicked := hover && rl.IsMouseButtonPressed(.LEFT)

    color := rl.LIGHTGRAY
    if hover {
        color = rl.GRAY
    }

    rl.DrawRectangleRec(b.rect, color)

    txt := strings.clone_to_cstring(b.label)
    defer delete(txt)

    rl.DrawText(txt, i32(b.rect.x)+10, i32(b.rect.y)+15, 20, rl.BLACK)

    return clicked
}


main :: proc() {
    rl.InitWindow(WIDTH, HEIGHT, "gnometd")
    
    player_img := rl.LoadTexture("assets/gnome.png")
    flower_img_1 := rl.LoadTexture("assets/flower1.png")
    enemy_icy := rl.LoadTexture("assets/front_face.png")
    treewee := rl.LoadTexture("assets/treewee.png")
    
    player: player = player{
	      {0, 0},
	      10,
	      10,
	      rl.GREEN
    }

    add_flow_btn := Button{ rl.Rectangle{50, 500, 100, 40}, "add flower" }
    setting_flower: bool = false

    for i in 0..<10 {
	      if i%2 == 0 {
	          append(&EnemyArray, Enemy{
		            {100, 100},
		            {-40, 120},
                50,
                enemy_icy
	          })
	      }
	      else {
	          append(&EnemyArray, Enemy{
		            {100, 100},
		            {120, -40},
                100,
                treewee
	          })
	      }
    }
    
    for (!rl.WindowShouldClose()) {
	      {
	          move_player(&player)
	          if draw_button(add_flow_btn) {
		            append(&FlowerArray, Flower{rl.GetMousePosition(), flower_type.orchid, 0, flower_img_1})
		            setting_flower = true
            }

	          if setting_flower {
		            mouse := rl.GetMousePosition()
		            rl.DrawRectangle(i32(mouse.x), i32(mouse.y), 10, 10, rl.RED)
	          }

	          if setting_flower {
		            if rl.IsMouseButtonReleased(.LEFT) {
		                setting_flower = false
		                FlowerArray[len(FlowerArray)-1].pos.x = f32(rl.GetMouseX())
		                FlowerArray[len(FlowerArray)-1].pos.y = f32(rl.GetMouseY())
		            }
	          }
	      }
	      
	      {
	          rl.BeginDrawing()
	          defer rl.EndDrawing()
	          rl.ClearBackground({92, 156, 24, 255*0.8})
	          /* draw_player(&player, player_img) */
	          draw_flowers(&FlowerArray)
	          /* rotate_flowers_to_mouse(&FlowerArray, rl.GetMousePosition()) */
            update_flowers_targeting(&FlowerArray, &EnemyArray)

	          draw_enemies(&EnemyArray)
	          move_enemies(&EnemyArray)
	      }
    }
    rl.CloseWindow()
}



rotate_flowers_to_mouse :: proc(flowers: ^[dynamic]Flower, aim_to: rl.Vector2) {
    for &flower in flowers {

        if rl.CheckCollisionPointCircle(aim_to, flower.pos, 250) {

            dx := aim_to.x - flower.pos.x
            dy := aim_to.y - flower.pos.y

            angle := math.atan2(dy, dx) * 180.0 / math.PI
            flower.rotation = f32(angle)
        }
    }
}
draw_player :: proc(player_char: ^player, player_img: rl.Texture2D) {
    rl.DrawTextureEx(player_img, {player_char.pos.x, player_char.pos.y}, 0, 5, rl.WHITE)

}

draw_enemies :: proc(enemies: ^[dynamic]Enemy) {
    for enemy in enemies {
	      rl.DrawTextureEx(enemy.texture, {enemy.pos.x, enemy.pos.y}, 0, 5, rl.WHITE)	
    }
}


draw_flowers :: proc(flowers: ^[dynamic]Flower) {
    for flower in flowers {
	      if flower.type == flower_type.orchid {
	          src := rl.Rectangle{0, 0, f32(flower.texture.width), f32(flower.texture.height)}
	          dst := rl.Rectangle{flower.pos.x, flower.pos.y, 32 * 5, 32 * 5}
	          origin := rl.Vector2{16 * 5, 16 * 5} // center pivot
	          
	          rl.DrawCircle(i32(flower.pos.x), i32(flower.pos.y), 250, {255, 255, 255, 100})
	          rl.DrawTexturePro(flower.texture, src, dst, origin, flower.rotation, rl.WHITE)
	      }

    }
}

move_enemies :: proc(enemies: ^[dynamic]Enemy) {
    for &enemy in enemies {
	      enemy.pos += enemy.vel * rl.GetFrameTime()

	      if enemy.pos.x >= WIDTH || enemy.pos.x <= 0 {
	          enemy.vel.x *= -1
	      }
	      
	      if enemy.pos.y >= HEIGHT || enemy.pos.y <= 0 {
	          enemy.vel.y *= -1
	      }
    }
}

move_player :: proc(player: ^player) {
    speed :f32 = 500.0 // pixels per seconde
    dt := rl.GetFrameTime()

    if rl.IsKeyDown(.UP) {
        player.pos.y -= speed * dt
    }
    if rl.IsKeyDown(.DOWN) {
        player.pos.y += speed * dt
    }
    if rl.IsKeyDown(.LEFT) {
        player.pos.x -= speed * dt
    }
    if rl.IsKeyDown(.RIGHT) {
        player.pos.x += speed * dt
    }
}

get_nearest_enemy_in_range :: proc(
    flower: Flower,
    enemies: ^[dynamic]Enemy,
    range: f32
) -> (Enemy, bool) {

    best_dist_sq := range * range
    found := false
    best_enemy: Enemy

    for enemy in enemies {
        dx := enemy.pos.x - flower.pos.x
        dy := enemy.pos.y - flower.pos.y

        dist_sq := dx*dx + dy*dy

        if dist_sq <= best_dist_sq {
            best_dist_sq = dist_sq
            best_enemy = enemy
            found = true
        }
    }

    return best_enemy, found
}

update_flowers_targeting :: proc(
    flowers: ^[dynamic]Flower,
    enemies: ^[dynamic]Enemy
) {
    range: f32 = 250

    for &flower in flowers {
        enemy, found := get_nearest_enemy_in_range(flower, enemies, range)

        if found {
            scale: f32 = 5.0

            flower_center := rl.Vector2{
                flower.pos.x + (f32(flower.texture.width) * scale) / 2,
                flower.pos.y + (f32(flower.texture.height) * scale) / 2,
            }

            enemy_center := rl.Vector2{
                enemy.pos.x + (f32(enemy.texture.width) * scale) / 2,
                enemy.pos.y + (f32(enemy.texture.height) * scale) / 2,
            }           
            dx := enemy_center.x - flower_center.x
            dy := enemy_center.y - flower_center.y


            angle := math.atan2(dy, dx) * 180.0 / math.PI
            flower.rotation = f32(angle)
        }
    }
}
