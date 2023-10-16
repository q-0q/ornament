extends State

@export var air_speed: float = 110

@onready var Fall = $"../FallFromAir"
@onready var line : Line2D = $"../../TetherManager/Line2D"
@onready var collision : CollisionShape2D = $"../../CollisionShape2D"
@export var tension_length : float = 5

var state_locked : bool = false
var swing_dir : float = 1
var enter_pos : Vector2
var time_elapsed : float
var previous_position

func _ready():
	pass

func _on_enter():
	Player.velocity = Vector2.ZERO
	state_locked = true
	
	enter_pos = Player.position
	time_elapsed = 0
	
	if Player.position.x < FSM.TetherManager.line.points[1].x: swing_dir = 1
	else: swing_dir = -1
	
func _on_exit():
	pass
	
func _on_update(delta):
	FSM._set_face_dir_from_input()
	
	if (!FSM.TetherManager.is_tethered): 
		state_locked = false
		return
	
	var transformed_pos = Player.position - line.points[1]
	var angle = delta * -4 * swing_dir
	var new_x = transformed_pos.x * cos(angle) - transformed_pos.y * sin(angle)
	var new_y = transformed_pos.y * cos(angle) + transformed_pos.x * sin(angle)
	var desired_position = Vector2(new_x, new_y) + line.points[1]
	
	#Player.position = desired_position
	Player.velocity = (desired_position - Player.position) * delta * 4000
		
	time_elapsed += delta
	
	if (FSM.input_jump or 
		Player.position.y < enter_pos.y - 10 or
		Player.is_on_wall() or Player.is_on_ceiling()):
		state_locked = false
	
func _stateless_condition():
	return FSM.TetherManager.is_tethered and FSM.TetherManager.is_at_tension()

