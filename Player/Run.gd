extends State
@export var run_speed : float = 100.0
@export var velocity_curve : Curve
@export var time_to_max_speed : float = 0.1

var time_elapsed : float = 0
var first_frame : bool = false

func _on_enter():
	time_elapsed = 0
	FSM.has_dash = true
	FSM.aq.play("run")
	first_frame = true
	
func _on_exit():
	pass
	
func _on_update(delta):
	var desired_speed = run_speed * \
		FSM.input_dir.x
		
	Player.velocity.x = lerp(desired_speed, 0.0, (1/FSM.ground_stop_factor))
	
	if !first_frame and FSM.force_walk_timer <= 0:
		FSM._set_face_dir_from_input()
	
	first_frame = false
	time_elapsed += delta
	
func _stateless_condition():
	return (
		!SceneManager.is_switching_scenes and
		FSM.input_dir.x != 0 and
		Player.is_on_floor())
