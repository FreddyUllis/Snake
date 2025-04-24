extends Panel

var constants_path_scene: Node = preload("res://Other/Scripts/constants_path_scene.gd").new()

@onready var speed_name_label: Label = get_node(constants_path_scene.SPEED_NAME_LABEL)


func set_speed(name_label: String) -> void:
	speed_name_label.text = name_label
