extends State

var state_locked : bool = false
var time_elapsed : float = 0
var attack_time : float

@export var velocity_curve : Curve
@export var forward_speed : float

func _on_enter():
	FSM.time_since_last_attack = FSM.input_buffer_length * 2
	Player.velocity = Vector2.ZERO
	state_locked = true
	time_elapsed = 0
	attack_time = FSM.aq.animate.get_animation("groundattack1").length
	FSM.aq.force("groundattack1", attack_time)
	FSM.last_attack_type = 1
	FSM.attack_timer = 0
	
func _on_exit():
	pass
	
func _on_update(delta):
	state_locked = (time_elapsed <= attack_time)
	time_elapsed += delta
	
	var dir_mod = 1 if FSM.is_facing_right else -1
	
	Player.velocity.x = \
					dir_mod * \
					forward_speed * \
					velocity_curve.sample(time_elapsed / attack_time)
	
func _stateless_condition():
	return FSM.input_attack
