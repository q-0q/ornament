extends Node

class_name PersistentTilemapEvent

@onready var tilemap : TileMap = $TileMap

func _ready():
	PteManager.pte_ready(self)

func execute():
	pass
	
func set_to_executed_state():
	pass
