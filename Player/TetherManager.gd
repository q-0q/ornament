extends Node

var max_tether_distance : float = 50
@onready var line : Line2D = $Line2D
@onready var TetherCast = $"../TetherCast"
@onready var Player = $".."

var is_tethered : bool = false

func _process(delta):
	if !is_tethered: return
	line.points[0] = Player.position
	
func is_able_to_tether():
	return TetherCast.is_colliding()
	
func create_tether():
	is_tethered = true
	line.add_point(Player.position)	
	line.add_point(TetherCast.get_collision_point())
	
func break_tether():
	is_tethered = false
	line.clear_points()

func get_tether_length():
	return line.points[0].distance_to(line.points[1])

func is_at_tension():
	if !is_tethered: return false
	print(line.points.size())	
	return get_tether_length() > max_tether_distance
