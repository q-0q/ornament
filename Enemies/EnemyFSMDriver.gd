extends Node

class_name EnemyFSMDriver

var current_state : EnemyState
var time_in_current_state : float = 0
var is_facing_right : bool = true
var home_position : Vector2

var rng = RandomNumberGenerator.new()

@export var EnemyStates : EnemyStates
@onready var aq : AnimationQueue = $"../AnimationQueue"
@onready var sprite : Sprite2D = $"../Sprite2D"
@onready var Enemy : CharacterBody2D = $".."
@onready var force : ForceManager = $"../ForceManager"
@onready var cliff : CliffDetector = $"../Sprite2D/CliffDetector"

func _ready():
	
	if EnemyStates == null:
		print("YOU FORGOT TO ASSIGN THE EnemyStates OVERRIDE ON " + Enemy.name)
	
	for child in EnemyStates.get_children():

		child.Enemy = Enemy
		child.driver = self
	
	EnemyStates.driver = self
	current_state = EnemyStates.default_state
	home_position = Enemy.position

func _process(delta):
	var new_state = EnemyStates._determine_new_state()
	if new_state != current_state:
		current_state._on_exit()
		current_state = new_state
		current_state._on_enter()
		time_in_current_state = 0
	
	current_state._on_update(delta)
	force.do_force()
	time_in_current_state += delta
	$"../debug_text".text = current_state.name
	
	Enemy.move_and_slide()
	
func _set_face_dir(dir : bool):
	if (dir):
		is_facing_right = true
		sprite.scale.x = 1;
	else:
		is_facing_right = false
		sprite.scale.x = -1;
