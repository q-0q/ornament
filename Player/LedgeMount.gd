extends State

@export var mount_speed = 20

@onready var PlayerCollider : CollisionShape2D = $"../../CollisionShape2D"

var state_locked : bool = true

func _on_enter():
	FSM.aq.play("mount")
	FSM.has_dash = true
	state_locked = true
	PlayerCollider.set_deferred("disabled", true)
	
func _on_exit():
	PlayerCollider.set_deferred("disabled", false)
	
func _on_update(delta):
	if FSM.BottomCast.is_colliding():
		Player.velocity.y = -mount_speed
		if FSM.is_facing_right:
			Player.velocity.x = mount_speed
		else:
			Player.velocity.x = -mount_speed
	else:
		Player.velocity.y = 0
		state_locked = false
		
func _stateless_condition():
	return (
	FSM.BottomCast.is_colliding() and
	!FSM.TopCast.is_colliding()
	)
			
