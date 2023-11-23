extends Node

var spawner_killed = {}

func _ready():
	respawn_all()

func respawn_all():
	print("All enemies respawned!")
	spawner_killed.clear()

func set_spawner_killed(spawner : Spawner):
	spawner_killed[spawner.get_path()] = true

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		respawn_all()
