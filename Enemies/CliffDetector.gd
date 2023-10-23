extends Node2D

class_name CliffDetector
@export var max_drop_height : float
@onready var cast = $RayCast2D

var timer : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	cast.target_position.y = max_drop_height
	
func _process(delta):
	if !cast.is_colliding(): timer = 0
	timer += delta
	
func will_fall():
	return false
	return timer < 0.1
