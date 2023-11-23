extends Node

var executed = {}

func _ready():
	reset_all()

func reset_all():
	print("All PTEs reset!")
	executed.clear()
	
func pte_ready(pte : PersistentTilemapEvent):
	if executed.has(pte.get_path()):
		pte.set_to_executed_state()
	
func try_execute(pte : PersistentTilemapEvent):
	if executed.has(pte.get_path()): return
	pte.execute()
	executed[pte.get_path()] = true

func _process(delta):
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			reset_all()
