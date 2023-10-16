extends State

@export var jump_strength : float
@export var outward_jump_strength_ratio : float = 0.5
@export var jump_time : float
@export var velocity_curve : Curve
@export var air_speed : float = 100.0
@export var time_until_controllable : float = 0.1

var time_elapsed : float = 0
var jump_held : bool = true

func _on_enter():
	print("enter wallrise")
	if (FSM.MiddleCast.is_colliding() or FSM.TopCast.is_colliding()): FSM._flip_face_dir()
	FSM.time_since_last_jump = FSM.input_buffer_length * 2
	jump_held = true
	time_elapsed = 0
	
func _on_exit():
	pass
	
func _on_update(delta):
	
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
	
	if time_elapsed > time_until_controllable:
		Player.velocity.x = air_speed * FSM.input_dir.x
	else:
		var dir_mod : int
		if FSM.is_facing_right:
			dir_mod = 1 
		else: dir_mod = -1
		Player.velocity.x = outward_jump_strength_ratio * jump_strength * dir_mod

	time_elapsed += delta
	
func _stateless_condition():
	return FSM.input_jump
