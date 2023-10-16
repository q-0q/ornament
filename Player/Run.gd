extends State
@export var run_speed : float = 100.0
@export var velocity_curve : Curve
@export var time_to_max_speed : float = 0.1

var time_elapsed : float = 0

func _on_enter():
	time_elapsed = 0
	FSM.has_dash = true
	FSM.aq.play("run")
	
func _on_exit():
	pass
	
func _on_update(delta):
	var desired_speed = run_speed * \
		FSM.input_dir.x
		
	Player.velocity.x = lerp(desired_speed, float(0), (delta * FSM.ground_stop_factor))
		
	FSM._set_face_dir_from_input()
	time_elapsed += delta
	
func _stateless_condition():
	return (
		FSM.input_dir.x != 0 and
		Player.is_on_floor())
