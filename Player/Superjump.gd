extends State

@onready var Rise = $"../Rise"

func _on_enter():
	Rise._on_enter()
	
func _on_exit():
	Rise._on_exit()
	
func _on_update(delta):
	Rise._on_update(delta)
	if (FSM.input_dir.x != 0):
		Player.velocity.x *= 1.4
	Player.velocity.y *= 0.7
	
func _stateless_condition():
	return Rise._stateless_condition()

