extends Area2D

var constants_num: Node = preload("res://Other/Scripts/constants_num.gd").new()
var body_scene: PackedScene = preload("res://SnakeSegment/Scenes/snake_body.tscn")

var direction: Vector2 = Vector2.RIGHT
var next_direction: Vector2 = Vector2.RIGHT
var body: Array = []
var grid_size: Vector2i = Vector2i(
		constants_num.FOOD_VECTOR,
		constants_num.FOOD_VECTOR
	)


func _init_snake() -> void:
	_delete_body_snake()
	
	var head: Dictionary = {
		"position": position,
		"node": self
	}
	body = [head]
	position = Vector2(
		constants_num.GAME_OVER_FOOD_VECTOR,
		constants_num.FOOD_VECTOR
	)
	direction = Vector2.RIGHT
	next_direction = Vector2.RIGHT
	
	for _i in range(constants_num.START_SEGMENTS):
		add_body_segment()

func _delete_body_snake() -> void:
	for segment in body.slice(1):
		if is_instance_valid(segment["node"]) and segment["node"] != self:
			segment["node"].call_deferred("queue_free")
				
	body.resize(1)
	
	if body.size() > 0:
		body = [body[0]]

func game_over() -> void:
	_delete_body_snake()
	position = Vector2(
		constants_num.GAME_OVER_FOOD_VECTOR,
		constants_num.FOOD_VECTOR
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_up") and direction != Vector2.DOWN:
		next_direction = Vector2.UP
	elif  event.is_action_pressed("move_down") and direction != Vector2.UP:
		next_direction = Vector2.DOWN
	elif  event.is_action_pressed("move_right") and direction != Vector2.LEFT:
		next_direction = Vector2.RIGHT
	elif  event.is_action_pressed("move_left") and direction != Vector2.RIGHT:
		next_direction = Vector2.LEFT

func add_body_segment() -> void:
	var new_segment: Node = body_scene.instantiate()
	
	get_parent().call_deferred("add_child", new_segment)
	
	var last_pos: Vector2 = body[-1]["position"] - direction * constants_num.CELL_SIZE
	
	new_segment.position = last_pos
	body.append(
		{
			"position": last_pos,
			"node": new_segment
		}
	)

func move() -> void:
	direction = next_direction
	var new_head_pos: Vector2 = body[0]["position"] + direction * constants_num.CELL_SIZE
	
	if (
		new_head_pos.x < 0 or new_head_pos.x >= grid_size.x * constants_num.CELL_SIZE or
		new_head_pos.y < 0 or new_head_pos.y >= grid_size.y * constants_num.CELL_SIZE
		):
			get_parent().game_over()
			return
			
	var prev_pos: Vector2 = body[0]["position"] 
	body[0]["position"] = new_head_pos
	position = new_head_pos
	
	for i in range(1, body.size()):
		var current_pos: Vector2 = body[i]["position"]
		body[i]["position"] = prev_pos
		body[i]["node"].position = prev_pos
		prev_pos = current_pos

func grow() -> void:
	add_body_segment()

func check_self_collision() -> void:
	for i in range(1, body.size()):
		if body[0]["position"] == body[i]["position"]:
			get_parent().game_over()
			return
