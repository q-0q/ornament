extends State

@export var dash_strength : float = 10
@export var dash_time : float = 30
@export var velocity_curve : Curve
var time_elapsed : float = 0

var state_locked : bool = true

func _on_enter():
	FSM._set_face_dir_from_input()
	FSM.aq.play("grounddash")
	FSM.time_since_last_dash = FSM.input_buffer_length * 2
	Player.velocity.y = 0
	state_locked = true
	time_elapsed = 0
	
func _on_exit():
	pass
	
func _on_update(delta):
	
	var dir_mod = 1 if FSM.is_facing_right else -1
	
	Player.velocity.x = \
					dir_mod * \
					dash_strength * \
					velocity_curve.sample(time_elapsed / dash_time)
					
	time_elapsed += delta
	
	if time_elapsed > dash_time: state_locked = false
	
func _stateless_condition():
	return (FSM.unlocked_grounddash and FSM.input_dash)
