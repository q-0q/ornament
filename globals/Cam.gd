extends Node2D

var zones : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var closest_point : Vector2	
	if zones == null: closest_point = Util.player_position
	elif zones.get_child_count() == 0: closest_point = Util.player_position
	else:
		closest_point = zones.get_child(0).get_point()
		for child in zones.get_children():
			var current_distance : float = closest_point.distance_squared_to(Util.player_position)
			var new_distance : float = child.get_point().distance_squared_to(Util.player_position)
			current_distance = min(current_distance, new_distance)
	$Camera2D.position = closest_point
