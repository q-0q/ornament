extends State

@onready var GroundDash = $"../GroundDash"
var state_locked : bool = true
var time_elapsed : float = 0

func _on_enter():
	if FSM.MiddleCast.is_colliding(): FSM._flip_face_dir()
	FSM.time_since_last_dash = FSM.input_buffer_length * 2
	FSM.has_dash = false
	state_locked = true
	time_elapsed = 0
	GroundDash._on_enter()
	
func _on_exit():
	GroundDash._on_exit()
	
func _on_update(delta):
	GroundDash._on_update(delta)
	time_elapsed += delta
	if time_elapsed > GroundDash.dash_time: state_locked = false
	
func _stateless_condition():
	return (
	GroundDash._stateless_condition() and 
	FSM.has_dash
	and FSM.unlocked_airdash
	)
