extends Node

var speed: String = "Normal"
var music_enabled: bool = true
var sound_volume: float = 0.2
var texture_rect_img_menu: String = "texture_v1"
var background: String = "bg_v1"

func set_texture_rect_img_menu(key: String) -> void:
	texture_rect_img_menu = key
	
func get_texture_rect_img_menu() -> String:
	return texture_rect_img_menu
	
func set_background(key: String) -> void:
	background = key
	
func get_background() -> String:
	return background
 
func set_speed(new_speed: String) -> void:
	speed = new_speed

func get_speed() -> String:
	return speed

func set_music_enabled(enabled: bool) -> void:
	music_enabled = enabled

func is_music_enabled() -> bool:
	return music_enabled

func set_sound_volume(volume: float) -> void:
	sound_volume = clamp(volume, 0.0, 5.0)

func get_sound_volume() -> float:
	return sound_volume

func reset_to_defaults() -> void:
	texture_rect_img_menu = "texture_v1"
	background = "bg_v1"
	speed = "Normal"
	music_enabled = true
	sound_volume = 0.2
