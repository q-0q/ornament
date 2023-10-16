extends State

@export var freeze_time : float = 1

var time_elapsed : float = 0
var state_locked : bool = false

func _on_enter():
	Player.velocity = Vector2.ZERO
	time_elapsed = 0
	state_locked = true
	FSM.TetherManager.break_tether()
	
func _on_exit():
	pass
	
func _on_update(delta):
	
	time_elapsed += delta
	if time_elapsed > freeze_time: state_locked = false
	if FSM.TetherManager.is_tethered: return
	if FSM.TetherManager.is_able_to_tether(): FSM.TetherManager.create_tether()
	
	
func _stateless_condition():
	return FSM.input_grapple and FSM.unlocked_tether
