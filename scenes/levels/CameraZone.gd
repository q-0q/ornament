extends Area2D

class_name CameraZone

var rect : Rect2

var limit_top : float
var limit_bottom : float
var limit_left : float
var limit_right : float

# Called when the node enters the scene tree for the first time.
func _ready():
	rect = $CollisionShape2D.shape.get_rect()
	limit_top = rect.size.y / -2
	limit_bottom = rect.size.y / 2
	limit_left = rect.size.x / -2
	limit_right = rect.size.x / 2

func get_closest_local_point(pos : Vector2):
	var out_clamp_x : float = max(limit_left, pos.x)
	out_clamp_x = min(limit_right, out_clamp_x)
	var out_clamp_y : float = max(limit_top, pos.y)
	out_clamp_y = min(limit_bottom, out_clamp_y)
	
	return Vector2(out_clamp_x, out_clamp_y)
	
func get_point():
	var pos : Vector2 = Util.player_position - $CollisionShape2D.global_position	
	return get_closest_local_point(pos) + $CollisionShape2D.global_position
	

