package game

import "core:encoding/json"
import "core:fmt"
import "core:os/"
import rl "vendor:raylib"

WIN_WIDTH: i32 = 1280
WIN_HEIGHT: i32 = 720

Player :: struct {
	radius:   f32,
	position: rl.Vector2,
	velocity: f32,
	rotation: f32,
	color:    rl.Color,
}

TileMap :: struct {
	width:       int,
	height:      int,
	tile_width:  int,
	tile_height: int,
	layers:      []TileLayer,
}

TileLayer :: struct {
	name:   string,
	data:   []int,
	width:  int,
	height: int,
}

main :: proc() {
	rl.InitWindow(WIN_WIDTH, WIN_HEIGHT, "My First Game")
	rl.SetExitKey(rl.KeyboardKey.ESCAPE)
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.SetTargetFPS(500)

	player := Player {
		radius   = 20,
		position = rl.Vector2{(f32)(rl.GetScreenWidth() / 2), (f32)(rl.GetScreenHeight() / 2)},
		rotation = 0,
		color    = rl.WHITE,
		velocity = 1,
	}

	camera := rl.Camera2D {
		target   = player.position,
		offset   = player.position,
		rotation = player.rotation,
		zoom     = 1,
	}

    load_tilemap("./map/test-level.json")

	for !rl.WindowShouldClose() {
		if (rl.IsKeyDown(rl.KeyboardKey.ESCAPE)) {
			break
		}

		// MAP

		// MOVEMENT
		move(&player.position, player.velocity)

		camera.target = player.position

		rl.ClearBackground(rl.BLACK)
		rl.BeginDrawing()
		rl.DrawFPS(10, 10)

		rl.BeginMode2D(camera)

		rl.DrawText("Move: WASD", 20, WIN_HEIGHT - 100, 20, rl.WHITE)
		rl.DrawText("Shoot: SPACE", 20, WIN_HEIGHT - 60, 20, rl.WHITE)
		rl.DrawText("Exit: ESC", 20, WIN_HEIGHT - 20, 20, rl.WHITE)

		rl.DrawCircleV(player.position, player.radius, player.color)

		rl.EndMode2D()
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
		speed *= 1.5
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


//
// MAP PARSER
// 


load_tilemap :: proc(file_name: string) -> TileMap {
    content, _ := os.read_entire_file_from_filename(file_name)
    data, _ := json.parse(content)
    fmt.print()
	// layers : [dat.len]TileLayer

	// for i, layer_data in data["layers"] {
	// 	layers[i] = TileLayer {
	// 		name   = layer_data["name"].(string),
	// 		data   = layer_data["data"].([]int),
	// 		width  = layer_data["width"].(int),
	// 		height = layer_data["height"].(int),
	// 	}
	// }

	// return TileMap {
	// 	width = data["width"].(int),
	// 	height = data["height"].(int),
	// 	tile_width = data["tilewidth"].(int),
	// 	tile_height = data["tileheight"].(int),
	// 	layers = layers,
	// }

    return TileMap{}
}
