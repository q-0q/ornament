extends Area2D

class_name Doorway

@export var dest_scene_path : String
@export var dest_door_name : String

func _on_area_entered(area):
	pass


func _on_body_entered(body):
	if(!body.can_enter_doors): return
	SceneManager.on_doorway_entered(self, body)

func _on_body_exited(body):
	body.can_enter_doors = true
