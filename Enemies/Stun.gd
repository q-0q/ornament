extends EnemyState


func _on_enter():
	is_locked = true
	
func _on_exit():
	driver.current_knockback = Vector2.ZERO
	
func _on_update(delta):
	Enemy.velocity = Vector2.ZERO
	is_locked = driver.current_knockback.length() > 0.2
	print(driver.current_knockback)
	
func _stateless_condition():
	return driver.current_knockback != Vector2.ZERO
