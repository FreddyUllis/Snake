extends Control

const constants_path_scene := preload("res://Other/Scripts/constants_path_scene.gd")
const constants_path_str := preload("res://Other/Scripts/constants_str.gd")

@onready var parent_panel: Panel = get_parent()
@onready var text_game_label: Label = get_node(constants_path_scene.TEXT_GAME_LABEL)
@onready var blink_timer: Timer = get_node(constants_path_scene.BLINK_TIMER)

var is_visible_flag: bool = true

func _ready() -> void:
	blink_timer.timeout.connect(_on_blink_timer_timeout)

func _start_timer() -> void:
	text_game_label.text = ""
	text_game_label.visible = false
	blink_timer.start()
	text_game_label.text = constants_path_str.PRESS_START_TO_GAME
	text_game_label.visible = true
	parent_panel.visible = true

func _on_blink_timer_timeout() -> void:
	is_visible_flag = not is_visible_flag
	text_game_label.visible = is_visible_flag

func stop_timer_visible_menu(is_stop: bool, is_game_paused: bool) -> void:
	if not is_game_paused:
		if is_stop:
			blink_timer.stop()
		else:
			blink_timer.start()

func stop_timer() -> void:
	text_game_label.text = ""
	text_game_label.visible = false
	blink_timer.stop()
	parent_panel.visible = false

func game_over() -> void:
	text_game_label.text = constants_path_str.GAME_OVER
	text_game_label.visible = true
	parent_panel.visible = true

func pause_game() -> void:
	text_game_label.text = constants_path_str.PAUSED
	text_game_label.visible = true
	parent_panel.visible = true

func resume_game() -> void:
	text_game_label.text = ""
	text_game_label.visible = false
	parent_panel.visible = false
