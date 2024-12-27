package game

import rl "vendor:raylib"
import "core:fmt"

WIN_WIDTH: i32 = 800
WIN_HEIGHT: i32 = 600

Player :: struct {
    width: f32,
    height: f32,
	vertice1: rl.Vector2,
	vertice2: rl.Vector2,
	vertice3: rl.Vector2,
    position: rl.Vector2,
    velocity: f32,
    rotation: f32,
    color: rl.Color
}

main :: proc() {
	rl.InitWindow(WIN_WIDTH, WIN_HEIGHT, "My First Game")
	rl.SetExitKey(rl.KeyboardKey.ESCAPE)
	rl.SetTargetFPS(60)

    player := Player{
        width = 20,
        height = 20,
        position = rl.Vector2{(f32)(rl.GetScreenWidth() / 2), (f32)(rl.GetScreenHeight() / 2)},
        rotation = 0,
        color = rl.WHITE
    }

    player.vertice1 = rl.Vector2{(f32)(WIN_WIDTH / 2), (f32)(WIN_HEIGHT / 2) - player.height / 2}
    player.vertice2 = rl.Vector2{(f32)(WIN_WIDTH / 2) - player.width / 2, (f32)(WIN_HEIGHT / 2) + player.height / 2}
    player.vertice3 = rl.Vector2{(f32)(WIN_WIDTH / 2) + player.width / 2, (f32)(WIN_HEIGHT / 2) + player.height / 2}

	for !rl.WindowShouldClose() {
        if (rl.IsKeyDown(rl.KeyboardKey.ESCAPE)) {
            break;
        }

		// MOVEMENT
		move(&player.position, player.velocity)

		rl.ClearBackground(rl.BLACK)
		rl.BeginDrawing()
		rl.DrawFPS(10, 10)

        rl.DrawText("Move: WASD", 20, WIN_HEIGHT - 100, 20, rl.WHITE)
        rl.DrawText("Shoot: SPACE", 20, WIN_HEIGHT - 60, 20, rl.WHITE)
        rl.DrawText("Exit: ESC", 20, WIN_HEIGHT - 20, 20, rl.WHITE)

		rl.DrawTriangle(player.vertice1, player.vertice2, player.vertice3, player.color)

		rl.EndDrawing()
	}

	rl.CloseWindow()
}

//
// MOVEMENT
//

move :: proc(position: ^rl.Vector2, velocity: f32) {
    speed: f32 = velocity

    if rl.IsKeyDown(rl.KeyboardKey.LEFT_SHIFT) {
        speed += 2.5
    }

    if rl.IsKeyDown(rl.KeyboardKey.W) {
        position.y -= speed
    }

    if rl.IsKeyDown(rl.KeyboardKey.S) {
        position.y += speed
    }

    if rl.IsKeyDown(rl.KeyboardKey.A) {
        position.x -= speed
    }

    if rl.IsKeyDown(rl.KeyboardKey.D) {
        position.x += speed
    }
}