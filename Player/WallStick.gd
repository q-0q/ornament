extends State

@export var fall_speed : float
@export var time_to_max_fall_speed : float
@export var velocity_curve : Curve
var time_elapsed : float = 0

func _on_enter():
	FSM.has_dash = true
	time_elapsed = 0
	Player.velocity = Vector2.ZERO
	#print(FSM.MiddleCast.get_collider().get_path())
	
func _on_exit():
	pass
	
func _on_update(delta):
	if (time_elapsed < time_to_max_fall_speed):
		Player.velocity.y = fall_speed * velocity_curve.sample(time_elapsed / time_to_max_fall_speed)
	else: 
		Player.velocity.y = fall_speed
		
	if (Player.velocity.y < 80):
		FSM.aq.force("wallcling1")
	else:
		FSM.aq.play("wallcling2")
	
	time_elapsed += delta
	
func _stateless_condition():
	return (
		FSM.unlocked_walljump and
		(FSM.MiddleCast.is_colliding() or FSM.BottomCast.is_colliding()) and
		FSM.input_dir.x != 0 and
		((FSM.input_dir.x == 1) == FSM.is_facing_right)
		)
