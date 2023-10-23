extends Node2D

class_name Spawner

@export var Enemy : PackedScene
var enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	if !SpawnManager.spawner_killed.has(get_path()):
		enemy = Enemy.instantiate()
		add_child(enemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (enemy == null):
		SpawnManager.set_spawner_killed(self)
