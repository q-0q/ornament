extends EnemyState


@export var aggro_range : float
@export var aggro_run_speed : float
@export var slipperyness : float

func _on_enter():
	driver.aq.animate.speed_scale = 3
	driver.aq.play("rat_walk")
	
func _on_exit():
	driver.aq.animate.speed_scale = 1
	
func _on_update(delta):
	var dir_mod = 1
	if Util.player_position.x < Enemy.position.x: dir_mod = -1
	Enemy.velocity.x = lerp(Enemy.velocity.x, aggro_run_speed * dir_mod, 1/slipperyness)
	driver._set_face_dir(dir_mod == -1)
		
	
func _stateless_condition():
	return(
		Util.player_position.distance_to(Enemy.position) < aggro_range
	)
