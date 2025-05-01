extends Node2D

const constants_path_scene := preload("res://Other/Scripts/constants_path_scene.gd")
const constants_num := preload("res://Other/Scripts/constants_num.gd")
const constants_str := preload("res://Other/Scripts/constants_str.gd")
const constants_collection := preload("res://Other/Scripts/constants_collection.gd")

@onready var snake: Area2D = get_node(constants_path_scene.SNAKE)
@onready var food: Area2D = get_node(constants_path_scene.FOOD)
@onready var move_timer: Timer = get_node(constants_path_scene.SNAKE_TIMER)
@onready var hud_label_score: Label = get_node(constants_path_scene.HUD_LABEL_SCORE)
@onready var hud_label_text_press_start: Control = get_node(constants_path_scene.HUD_LABEL_TEXT_PRESS_START)
@onready var hud_button_start: Button = get_node(constants_path_scene.HUD_BUTTON_START)
@onready var hud_button_pause: Button = get_node(constants_path_scene.HUD_BUTTON_PAUSE)
@onready var hud_button_exit: Button = get_node(constants_path_scene.HUD_BUTTON_EXIT)
@onready var hud_button_menu: Button = get_node(constants_path_scene.HUD_BUTTON_MENU)
@onready var hud_menu_control: Control = get_node(constants_path_scene.HUD_MENU_CONTROL)
@onready var hud_menu_button_close: Button = get_node(constants_path_scene.HUD_MENU_BUTTON_CLOSE)
@onready var hud_speed_name_label: Panel = get_node(constants_path_scene.HUD_SPEED_NAME_LABEL)
@onready var button_click_sound: AudioStreamPlayer = get_node(constants_path_scene.BUTTON_CLICK)
@onready var main_game_music: AudioStreamPlayer = get_node(constants_path_scene.MAIN_GAME_MUSIC)
@onready var snake_eat_apple: AudioStreamPlayer = get_node(constants_path_scene.SNAKE_EAT_APPLE)
@onready var destroy_snake: AudioStreamPlayer = get_node(constants_path_scene.DESTROY_SNAKE)
@onready var background: Sprite2D = get_node(constants_path_scene.BACKGROUND)
@onready var hud_texture_rect_button_right: Button = get_node(constants_path_scene.HUD_TEXTURE_RECT_BUTTON_RIGHT)
@onready var hud_texture_rect_button_left: Button = get_node(constants_path_scene.HUD_TEXTURE_RECT_BUTTON_LEFT)
@onready var hud_texture_rect: TextureRect = get_node(constants_path_scene.HUD_TEXTURE_RECT_SCENE)

var score: int
var is_game_active: bool = false
var is_game_paused: bool = false
var was_playing: bool = false
var save_music_game_position: float = 0.0

var _tex_idx: int
var _bg_idx: int
var _tex_keys := constants_collection.TEXTURE_RECT_IMG_MENU.keys()
var _bg_keys := constants_collection.BACKGROUND.keys()


func _ready() -> void:
	hud_button_pause.visible = false
	hud_button_pause.disabled = true
	hud_button_start.visible = true
	hud_button_start.disabled = false
	hud_menu_control.make_or_not_it_visible(false)
	
	_tex_idx = _tex_keys.find(Settings.get_texture_rect_img_menu())
	_bg_idx = _bg_keys.find(Settings.get_background())
	
	_apply_tex_preview()
	_apply_bg_preview()
	_apply_settings()
	
	hud_texture_rect_button_right.pressed.connect(_on_right_button_pressed)
	hud_texture_rect_button_left.pressed.connect(_on_left_button_pressed)
	
	hud_label_text_press_start._start_timer()
	hud_button_start.pressed.connect(_on_start_button_pressed)
	hud_button_pause.pressed.connect(_on_pause_button_pressed)
	hud_button_exit.pressed.connect(_on_exit_button_pressed)
	hud_button_menu.pressed.connect(_on_menu_button_pressed)
	hud_menu_button_close.pressed.connect(_on_menu_close_button_pressed)
	
	move_timer.timeout.connect(_on_timer_timeout)
	move_timer.stop()
	reset_game()

func _on_right_button_pressed() -> void:
	button_click_sound.play()
	_change_selection(1)
	
func _on_left_button_pressed() -> void:
	button_click_sound.play()
	_change_selection(-1)

func _change_selection(delta: int) -> void:
	_tex_idx = (_tex_idx + delta + _tex_keys.size()) % _tex_keys.size()
	_bg_idx  = (_bg_idx  + delta + _bg_keys.size())  % _bg_keys.size()
	_apply_tex_preview()
	_apply_bg_preview()

func _apply_tex_preview() -> void:
	var key = _tex_keys[_tex_idx]
	hud_texture_rect.texture = constants_collection.TEXTURE_RECT_IMG_MENU[key]
	
func _apply_bg_preview() -> void:
	var key = _bg_keys[_bg_idx]
	background.texture = constants_collection.BACKGROUND[key]

func _apply_settings() -> void:
	var timeout: float = constants_collection.SPEED_TIMEOUTS[Settings.get_speed()]
	move_timer.wait_time = timeout
	
	var volume_db: float = linear_to_db(Settings.get_sound_volume())
	
	if Settings.is_music_enabled():
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume_db)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), volume_db)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		game_music_play_or_stop()
		toggle_pause()

func toggle_pause() -> void:
	is_game_paused = not is_game_paused
	
	if is_game_paused:
		hud_button_menu.disabled = false
		hud_button_pause.text = constants_str.HUD_BUTTON_PAUSE_RESUME
		move_timer.paused = true
		hud_label_text_press_start.pause_game()
	else:
		hud_button_menu.disabled = true
		hud_button_pause.text = constants_str.HUD_BUTTON_PAUSE_PAUSE
		move_timer.paused = false
		hud_label_text_press_start.resume_game()

func _on_start_button_pressed() -> void:
	button_click_sound.play()
	main_game_music.play()
	
	if not is_game_active:
		start_game()

func game_music_play_or_stop() -> void:
	if main_game_music.playing:
		save_music_game_position = main_game_music.get_playback_position()
		main_game_music.stop()
	else:
		main_game_music.play(save_music_game_position)

func _on_pause_button_pressed() -> void:
	button_click_sound.play()
	game_music_play_or_stop()
	
	if is_game_active:
		toggle_pause()

func _on_exit_button_pressed() -> void:
	main_game_music.stop()
	button_click_sound.play()
	await button_click_sound.finished
	get_tree().quit()

func _on_menu_button_pressed() -> void:
	button_click_sound.play()
	hud_button_menu.disabled = true
	hud_button_start.disabled = true
	hud_button_pause.disabled = true
	hud_label_text_press_start.visible = false
	hud_label_text_press_start.stop_timer_visible_menu(true, is_game_paused)
	hud_menu_control.make_or_not_it_visible(true)
	hud_menu_control.disabled_speed_snake(is_game_paused)

func _on_menu_close_button_pressed() -> void:
	button_click_sound.play()
	hud_button_menu.disabled = false
	hud_button_start.disabled = false
	hud_button_pause.disabled = false
	hud_label_text_press_start.visible = true
	hud_label_text_press_start.stop_timer_visible_menu(false, is_game_paused)
	hud_menu_control.make_or_not_it_visible(false)
	hud_speed_name_label.set_speed(Settings.get_speed())
	
	Settings.set_texture_rect_img_menu(_tex_keys[_tex_idx])
	Settings.set_background(_bg_keys[_bg_idx])

func start_game() -> void:
	hud_button_pause.visible = true
	hud_button_pause.disabled = false
	hud_button_start.visible = false
	hud_button_start.disabled = true
	hud_button_menu.disabled = true
	
	is_game_active = true
	score = 0
	hud_label_score.text = str(score)
	snake._init_snake()
	await get_tree().process_frame
	food.move_random(
		Vector2i(constants_num.FOOD_VECTOR, constants_num.FOOD_VECTOR),
		constants_num.CELL_SIZE, snake.body
	)
	hud_label_text_press_start.stop_timer()
	move_timer.start()
	hud_button_start.disabled = true

func _on_timer_timeout() -> void:
	if is_game_active:
		snake.move()
		check_food_collision()
		snake.check_self_collision()

func check_food_collision() -> void:
	if snake.body[0]["position"] == food.position:
		snake_eat_apple.play()
		update_score()
		snake.grow()
		food.move_random(
			Vector2i(constants_num.FOOD_VECTOR, constants_num.FOOD_VECTOR),
			constants_num.CELL_SIZE, snake.body
		)

func update_score() -> void:
	score += 1
	hud_label_score.text = str(score) 

func reset_game() -> void:
	is_game_active = false
	main_game_music.stop()
	
	if snake:
		snake.game_over()
		
	if food:
		food.game_over()
		
	if move_timer:
		move_timer.stop()

func game_over() -> void:
	destroy_snake.play()
	reset_game()
	hud_button_pause.disabled = true
	hud_label_text_press_start.game_over()
	await get_tree().create_timer(constants_num.GAME_OVER_TIMER).timeout
	hud_label_text_press_start._start_timer()
	
	hud_button_pause.visible = false
	hud_button_start.visible = true
	hud_button_start.disabled = false
	hud_button_menu.disabled = false
