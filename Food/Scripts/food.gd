extends Area2D

var constants_num: Node = preload("res://Other/Scripts/constants_num.gd").new()

func move_random(grid_size: Vector2i, cell_size: int, snake_body: Array) -> void:
	var attempts: int = 0
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	
	while attempts < constants_num.MAX_ATTEMPTS:
		var new_pos: Vector2 = Vector2(
			int(rng.randi_range(1, grid_size.x - 1) * cell_size + cell_size / 2.0),
			int(rng.randi_range(1, grid_size.y - 1) * cell_size + cell_size / 2.0)
		)
		var is_on_snake: bool = false
		
		for segment in snake_body:
			if segment["position"] == new_pos:
				is_on_snake = true
				break
		
		if not is_on_snake:
			position = new_pos
			return
		
		attempts += 1
	position = Vector2(constants_num.ALL_SNAKE, constants_num.ALL_SNAKE)

func game_over() -> void:
	position = Vector2(
		constants_num.FOOD_VECTOR,
		constants_num.GAME_OVER_FOOD_VECTOR
	)
