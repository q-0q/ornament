extends State

@export var fall_speed : float
@export var time_to_max_fall_speed : float
@export var velocity_curve : Curve
@export var air_speed : float = 100.0
var time_elapsed : float = 0

func _on_enter():
	time_elapsed = 0
	
func _on_exit():
	pass
	
func _on_update(delta):
	FSM._set_face_dir_from_input()
	
	if (time_elapsed < time_to_max_fall_speed):
		Player.velocity.y = fall_speed * velocity_curve.sample(time_elapsed / time_to_max_fall_speed)
	else: 
		Player.velocity.y = fall_speed
	
	if (Player.velocity.y < 100):
		FSM.aq.play("fall1")
	elif (Player.velocity.y < 240):
		FSM.aq.play("fall2")
	elif (time_elapsed > 0.55):
		FSM.aq.play("fall3")
		
	
	if (FSM.input_dir.x != 0):
		Player.velocity.x = air_speed * FSM.input_dir.x
	else:
		Player.velocity.x = lerp(Player.velocity.x, float(0), (delta * FSM.air_stop_factor))
		
	
	time_elapsed += delta
	
func _stateless_condition():
	return (
		Player.velocity.y >= 0 and
		!Player.is_on_floor())
