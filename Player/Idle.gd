extends State

func _on_enter():
	FSM.has_dash = true
	Player.velocity.y = 0
	FSM.aq.play("idle")
	
func _on_exit():
	pass
	
func _on_update(delta):
	Player.velocity.x = lerp(Player.velocity.x, float(0), (delta * FSM.ground_stop_factor))
	pass

func _stateless_condition():
	return (
		FSM.input_dir.x == 0 and
		Player.is_on_floor())
