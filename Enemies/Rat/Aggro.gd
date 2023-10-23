extends EnemyState


@export var aggro_range : float
@export var aggro_run_speed : float
@export var slipperyness : float
@onready var vision = $"../../Sprite2D/EnemyVision"

var cur_run_speed : float
var player_vision_timer : float

func _on_enter():
	cur_run_speed = 0
	driver.aq.play("rat_aggro")
	player_vision_timer = 0
	
func _on_exit():
	pass
	
func _on_update(delta):
	var dir_mod = 1
	if Util.player_position.x < Enemy.global_position.x: dir_mod = -1
	cur_run_speed = lerp(cur_run_speed, aggro_run_speed * dir_mod, 1/slipperyness)
	if Enemy.get_position_delta().x == 0: cur_run_speed = 80
	Enemy.velocity.x = cur_run_speed
	driver._set_face_dir(dir_mod == -1)
	if vision.can_see_player(): player_vision_timer = 0
	player_vision_timer += delta
	
func _stateless_condition():
	return(
		vision.can_see_player() and
		!driver.cliff.will_fall()
	)
