extends State

var time_elapsed : float = 0
var land_time : float = 0

func _on_enter():
	var land_time = min(FSM.time_in_current_state * 0.3, 2.5)
	FSM.aq.play("land", land_time)
	
func _on_exit():
	pass
	
func _on_update(delta):
	pass
	
func _stateless_condition():
	return Player.is_on_floor()
