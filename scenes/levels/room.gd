extends Node2D

@export var cam_limit_left : int = -10000
@export var cam_limit_right : int = 10000
@export var cam_limit_top : int = -10000
@export var cam_limit_bottom : int = 10000
@export var init_player_position : Vector2

func _ready():
	pass
	
func _started():
	SceneManager.fade_in()
	
