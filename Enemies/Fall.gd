extends EnemyState

class_name RatFall

func _on_enter():
	pass
	
func _on_exit():
	driver.home_position = Enemy.position
	
func _on_update(delta):
	Enemy.velocity.y = 150
	
	
func _stateless_condition():
	return !Enemy.is_on_floor()
