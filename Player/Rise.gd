extends State

@export var jump_strength : float
@export var jump_time : float
@export var velocity_curve : Curve
@export var air_speed : float = 100.0
var time_elapsed : float = 0
var jump_held : bool = true

func _on_enter():
	FSM.TetherManager.break_tether()
	FSM.time_since_last_jump = FSM.input_buffer_length * 2
	jump_held = true
	time_elapsed = 0
	
func _on_exit():
	pass
	
func _on_update(delta):

	FSM._set_face_dir_from_input()
	
	if !Input.is_action_pressed("Jump"): time_elapsed = \
		max(time_elapsed, jump_time * 0.7)
	
	Player.velocity.y = \
					-1 * \
					jump_strength * \
					velocity_curve.sample(time_elapsed / jump_time)
					
	if (Player.velocity.y < -150):
		FSM.aq.force("rise1")
	elif (Player.velocity.y < -120):
		FSM.aq.play("rise2")
	else:
		FSM.aq.play("rise3")
					
	if (FSM.input_dir.x != 0):
		Player.velocity.x = air_speed * FSM.input_dir.x
	else:
		Player.velocity.x = lerp(Player.velocity.x, float(0), (delta * FSM.air_stop_factor))
	time_elapsed += delta

func _stateless_condition():
	return (FSM.input_jump or Player.velocity.y < 0)
