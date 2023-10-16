extends Node

class_name EnemyFSMDriver

var current_state : EnemyState
var time_in_current_state : float = 0
var is_facing_right : bool = true
var home_position : Vector2
var current_knockback : Vector2 = Vector2.ZERO

var rng = RandomNumberGenerator.new()

@export var EnemyStates : EnemyStates
@onready var aq : AnimationQueue = $"../AnimationQueue"
@onready var sprite : Sprite2D = $"../Sprite2D"
@onready var Enemy : CharacterBody2D = $".."

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
	do_knockback()
	time_in_current_state += delta
	$"../debug_text".text = current_state.name
	Enemy.move_and_slide()
	
func _set_face_dir(dir : bool):
	if (dir):
		is_facing_right = true
		sprite.flip_h = false;
	else:
		is_facing_right = false
		sprite.flip_h = true;
		
func do_knockback():
	current_knockback = current_knockback.lerp(Vector2.ZERO, get_process_delta_time() * 10)
	Enemy.velocity += current_knockback
	
func apply_new_knockback(player_is_facing_right, enemy_knockback_speed):
	var dir_mod : int
	if player_is_facing_right: dir_mod = 1
	else: dir_mod = -1
	current_knockback.x = enemy_knockback_speed * dir_mod
