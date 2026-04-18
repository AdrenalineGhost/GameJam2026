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
		{-40, 120}
	    })
	}
	else {
	    append(&EnemyArray, Enemy{
		{100, 100},
		{120, -40}
	    })
	}
    }
    
    for (!rl.WindowShouldClose()) {
	{
	    move_player(&player)
	    if draw_button(add_flow_btn) {
		append(&FlowerArray, Flower{rl.GetMousePosition(), flower_type.orchid, 0})
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
	    draw_flowers(&FlowerArray, flower_img_1)
	    rotate_flowers_to_mouse(&FlowerArray, rl.GetMousePosition())

	    draw_enemies(&EnemyArray, enemy_icy)
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

draw_enemies :: proc(enemies: ^[dynamic]Enemy, enemy_img: rl.Texture2D) {
    for enemy in enemies {
	rl.DrawTextureEx(enemy_img, {enemy.pos.x, enemy.pos.y}, 0, 5, rl.WHITE)	
    }
}


draw_flowers :: proc(flowers: ^[dynamic]Flower, flower_img_1: rl.Texture2D) {
    for flower in flowers {
	if flower.type == flower_type.orchid {
	    /* rl.DrawTextureEx(flower_img_1, {flower.pos.x + 50, flower.pos.y + 50}, flower.rotation, 5, rl.WHITE) */

	    src := rl.Rectangle{0, 0, f32(flower_img_1.width), f32(flower_img_1.height)}
	    dst := rl.Rectangle{flower.pos.x, flower.pos.y, 32 * 5, 32 * 5}
	    origin := rl.Vector2{16 * 5, 16 * 5} // center pivot
	    
	    rl.DrawCircle(i32(flower.pos.x), i32(flower.pos.y), 250, {255, 255, 255, 100})
	    rl.DrawTexturePro(flower_img_1, src, dst, origin, flower.rotation, rl.WHITE)
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
