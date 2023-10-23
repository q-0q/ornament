extends EnemyState

@onready var hp = $"../../HealthManager"
@onready var hurtbox_col = $"../../EnemyHurtbox/CollisionShape2D"

# Called when the node enters the scene tree for the first time.

func _on_enter():
	driver.aq.play("rat_die")
	hurtbox_col.disabled = true
	
func _on_exit():
	pass
	
func _on_update(delta):
	Enemy.velocity = Vector2.ZERO
	
	if driver.time_in_current_state > 1: Enemy.queue_free()
	
func _stateless_condition():
	return hp.current_health <= 0
