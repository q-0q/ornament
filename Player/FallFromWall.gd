extends State

@onready var FallFromAir = $"../FallFromAir"

func _on_enter():
	FallFromAir._on_enter()
	
func _on_exit():
	FallFromAir._on_exit()
	
func _on_update(delta):
	FallFromAir._on_update(delta)
	
func _stateless_condition():
	return FallFromAir._stateless_condition()
