extends EnemyState

@onready var Hurtbox : Area2D = $"../../EnemyHurtbox"
@onready var hp = $"../../HealthManager"

func _on_enter():
	Enemy.velocity = Vector2.ZERO
	is_locked = true
	
func _on_exit():
	pass
	
func _on_update(delta):
	Enemy.velocity = Vector2.ZERO
	is_locked = driver.time_in_current_state < 0.2
	
func _stateless_condition():
	# return driver.current_knockback != Vector2.ZERO
	return Hurtbox.has_overlapping_areas() and hp.current_health > 0

