extends Node

const SPEED_OPTIONS: Array[String] = ["Slow", "Normal", "Fast"]
const SPEED_TIMEOUTS: Dictionary = {
	"Slow": 0.1,
	"Normal": 0.080,
	"Fast": 0.060
}
const TEXTURE_RECT_IMG_MENU: Dictionary = {
	"texture_v1": preload("res://HUD/Art/Images/v1.png"),
	"texture_v2": preload("res://HUD/Art/Images/v2.png"),
	"texture_v3": preload("res://HUD/Art/Images/v3.png"),
	"texture_v4": preload("res://HUD/Art/Images/v4.png"),
}
const BACKGROUND: Dictionary = {
	"bg_v1": preload("res://Main/Art/Images/bg.png"),
	"bg_v2": preload("res://Main/Art/Images/bg2.png"),
	"bg_v3": preload("res://Main/Art/Images/bg3.png"),
	"bg_v4": preload("res://Main/Art/Images/bg4.png"),
}
