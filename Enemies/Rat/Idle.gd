extends EnemyState

class_name RatIdle

var max_idle_time : float

func _on_enter():
	Enemy.velocity = Vector2.ZERO
	max_idle_time = driver.rng.randf_range(1, 3)
	driver.aq.play("rat_idle")
	
func _on_exit():
	pass
	
func _on_update(delta):
	Enemy.velocity = Vector2.ZERO
	
func _stateless_condition():
	return Enemy.is_on_floor()
