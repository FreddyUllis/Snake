extends Control

var constants_path_scene: Node = preload("res://Other/Scripts/constants_path_scene.gd").new()
var constants_collection: Node = preload("res://Other/Scripts/constants_collection.gd").new()

@onready var music_toggle_check_button: CheckButton = get_node(constants_path_scene.MUSIC_TOGGLE_CHECK_BUTTON)
@onready var sound_volume_h_slider: HSlider = get_node(constants_path_scene.SOUND_VOLUME_H_SLIDER)
@onready var speed_menu_option_button: OptionButton = get_node(constants_path_scene.SPEED_MENU_OPTION_BUTTON)
@onready var main: Node2D = get_node(constants_path_scene.MAIN)

func _ready() -> void:
	
	for speed in constants_collection.SPEED_OPTIONS:
		speed_menu_option_button.add_item(speed)
		
	_reset_to_defaults()
	
	speed_menu_option_button.item_selected.connect(_on_speed_option_selected)
	music_toggle_check_button.toggled.connect(_on_music_check_toggled)
	sound_volume_h_slider.value_changed.connect(_on_sound_slider_changed)

func _reset_to_defaults() -> void:
	Settings.reset_to_defaults()
	
	var speed_index: int = constants_collection.SPEED_OPTIONS.find(
		Settings.get_speed()
	)
	
	if speed_index != -1:
		speed_menu_option_button.select(speed_index)
	
	music_toggle_check_button.button_pressed = Settings.is_music_enabled()
	sound_volume_h_slider.value = Settings.get_sound_volume()

func _on_speed_option_selected(index: int) -> void:
	var selected_speed: String = constants_collection.SPEED_OPTIONS[index]
	Settings.set_speed(selected_speed)
	_apply_speed()

func _on_music_check_toggled(button_pressed: bool) -> void:
	Settings.set_music_enabled(button_pressed)
	_apply_music()

func _on_sound_slider_changed(value: float) -> void:
	print(value)
	Settings.set_sound_volume(value)
	_apply_sound_volume()

func _apply_speed() -> void:
	var timeout: float = constants_collection.SPEED_TIMEOUTS[Settings.get_speed()]
	main.move_timer.wait_time = timeout

func _apply_music() -> void:
	if Settings.is_music_enabled():
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)

func _apply_sound_volume() -> void:
	var volume_db: float = linear_to_db(Settings.get_sound_volume())
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume_db)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), volume_db)

func make_or_not_it_visible(is_visible_flag: bool) -> void:
	visible = is_visible_flag
	make_disabled_or_enabled(is_visible_flag)

func make_disabled_or_enabled(is_disabled: bool) -> void:
	music_toggle_check_button.disabled = not is_disabled
	sound_volume_h_slider.editable = is_disabled
	speed_menu_option_button.disabled = not is_disabled

func disabled_speed_snake(is_game_paused: bool) -> void:
	speed_menu_option_button.disabled = is_game_paused
