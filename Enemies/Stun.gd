extends EnemyState


var prev_frame_knockback : float
func _on_enter():
	is_locked = true
	prev_frame_knockback = 0
	
func _on_exit():
	driver.current_knockback = Vector2.ZERO
	
func _on_update(delta):
	if prev_frame_knockback < driver.current_knockback.length(): 
		driver.aq.force("rat_hit")
		print("played animation")
		
	prev_frame_knockback = driver.current_knockback.length()
	Enemy.velocity = Vector2.ZERO
	is_locked = driver.current_knockback.length() > 5
	
func _stateless_condition():
	return driver.current_knockback != Vector2.ZERO
