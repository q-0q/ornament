extends EnemyState

class_name RatWalk

@export var wander_range : float
@export var walk_speed : float
var walk_dir_mod : int
var max_walk_time : float

func _on_enter():
	var x_diff_from_home = Enemy.position.x - driver.home_position.x
	
	if (x_diff_from_home > wander_range):
		walk_dir_mod = -1
	elif (x_diff_from_home < -wander_range):
		walk_dir_mod = 1
	else:
		walk_dir_mod = 1
		if randi() % 2 == 0: walk_dir_mod = -1
	
	max_walk_time = driver.rng.randf_range(1,3)
	
	driver._set_face_dir(walk_dir_mod == -1)
	
func _on_exit():
	pass
	
func _on_update(delta):
	Enemy.velocity.x = walk_speed * walk_dir_mod
	
func _stateless_condition():
	return true
