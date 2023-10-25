extends Node

class_name FSM

# progression
@export var unlocked_walljump : bool = false
@export var unlocked_grounddash : bool = false
@export var unlocked_airdash : bool = false
@export var unlocked_tether : bool = false

# tunables
@export var ground_stop_factor : float = 18
@export var air_stop_factor : float = 5
@export var coyote_time : float = 0.25
@export var input_buffer_length = 0.2
@export var attack_delay_length = 0.3
@export var cast_distance : float = 15
@export var player_knockback_speed : float = 50
@export var attack1_enemy_knockback: float = 50
@export var attack2_enemy_knockback: float = 50
@export var attack3_enemy_knockback: float = 50

# references
@onready var BottomCast : RayCast2D = $"../BottomCast"
@onready var TopCast : RayCast2D = $"../TopCast"
@onready var MiddleCast : RayCast2D = $"../MiddleCast"
@onready var TetherCast : RayCast2D = $"../TetherCast"
@onready var aq : AnimationQueue = $"../AnimationQueue"
@onready var PlayerSprite : Sprite2D = $"../PlayerSprite"
@onready var default_state : State = $Idle
@onready var Player : CharacterBody2D = $".."
@onready var TetherManager = $"../TetherManager"

# input
var input_dir : Vector2 = Vector2.ZERO
var input_jump : bool = false
var time_since_last_jump : float = input_buffer_length * 2
var input_dash : bool = false
var time_since_last_dash : float = input_buffer_length * 2
var input_grapple : bool = false
var input_attack : bool = false
var time_since_last_attack : float = input_buffer_length * 2
var attack_timer : float = attack_delay_length * 2
var last_attack_type : int = 0

# bookkeeping
var current_state : State
var time_in_current_state : float = 0
var is_facing_right : bool = true
var has_dash : bool = false
var is_tethered : bool = false
var tether_distance : float = 10
var current_knockback : Vector2 = Vector2.ZERO
var force_walk_timer = 0

func _ready():
	_set_face_dir_from_input()
	tether_distance = $"../TetherManager".max_tether_distance
	
	for child in get_children():
		child.Player = Player
		child.FSM = self
		
	current_state = default_state
		
func _process(delta):
	#if SceneManager.is_switching_scenes: return
	
	_read_input(delta)
	
	var new_state = _determine_new_state()
	if new_state != current_state:
		current_state._on_exit()
		current_state = new_state
		current_state._on_enter()
		time_in_current_state = 0
		
	current_state._on_update(delta)
	do_knockback()
	time_in_current_state += delta
	attack_timer += delta
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): unlocked_grounddash = true
	
func _read_input(delta):
	# movement
	input_dir = Vector2.ZERO
	if Input.is_action_pressed("Left"):
		input_dir += Vector2.LEFT
	if Input.is_action_pressed("Right"):
		input_dir += Vector2.RIGHT
	if Input.is_action_pressed("Up"):
		input_dir += Vector2.UP
	if Input.is_action_pressed("Down"):
		input_dir += Vector2.DOWN
		
	force_input()
	
	# jump
	if Input.is_action_just_pressed("Jump"): time_since_last_jump = 0
	input_jump = (time_since_last_jump <= input_buffer_length)
	time_since_last_jump += delta
	
	# attack
	if Input.is_action_just_pressed("Attack"): time_since_last_attack = 0
	input_attack = (time_since_last_attack <= input_buffer_length)
	time_since_last_attack += delta
	
	# dash
	if Input.is_action_just_pressed("Dash"): time_since_last_dash = 0
	input_dash = (time_since_last_dash <= input_buffer_length)
	time_since_last_dash += delta
	
	# grapple
	input_grapple = Input.is_action_just_pressed("Grapple")
	

func _determine_new_state():
	
	# I can do whatever I want
	if SceneManager.is_switching_scenes:
		return $Idle
	
	if current_state == $Idle:
		if $Run._stateless_condition(): return $Run
		if $Rise._stateless_condition(): return $Rise
		if $FallFromGround._stateless_condition(): return $FallFromGround
		if $GroundDash._stateless_condition(): return $GroundDash
		if $GroundAttack3._stateless_condition() and \
			can_do_delayed_attack3(): return $GroundAttack3
		if $GroundAttack2._stateless_condition() and \
			can_do_delayed_attack2(): return $GroundAttack2
		if $GroundAttack1._stateless_condition(): return $GroundAttack1
		
	if current_state == $Run:
		if $Idle._stateless_condition(): return $Idle
		if $Rise._stateless_condition(): return $Rise
		if $FallFromGround._stateless_condition(): return $FallFromGround
		if $GroundDash._stateless_condition(): return $GroundDash
		if $GroundAttack3._stateless_condition() and \
			can_do_delayed_attack3(): return $GroundAttack3
		if $GroundAttack2._stateless_condition() and \
			can_do_delayed_attack2(): return $GroundAttack2
		if $GroundAttack1._stateless_condition(): return $GroundAttack1
		
	if current_state == $Rise or current_state == $WallRise or current_state == $Superjump:
		if $FallFromAir._stateless_condition(): return $FallFromAir
		if $LedgeMount._stateless_condition(): return $LedgeMount
		if $AirDash._stateless_condition(): return $AirDash
		if $ThrowTether._stateless_condition(): return $ThrowTether
		
	if current_state == $FallFromAir:
		if $Land._stateless_condition(): return $Land
		if $Idle._stateless_condition(): return $Idle
		if $Run._stateless_condition(): return $Run
		if $LedgeMount._stateless_condition(): return $LedgeMount
		if $AirDash._stateless_condition(): return $AirDash
		if $WallStick._stateless_condition(): return $WallStick
		if $ThrowTether._stateless_condition(): return $ThrowTether
		if $TetherSwing._stateless_condition(): return $TetherSwing
			
	if current_state == $FallFromGround:
		if $Land._stateless_condition(): return $Land
		if $Idle._stateless_condition(): return $Idle
		if $Run._stateless_condition(): return $Run
		if time_in_current_state <= coyote_time \
			and $Rise._stateless_condition(): return $Rise
		if $AirDash._stateless_condition(): return $AirDash
		if $WallStick._stateless_condition(): return $WallStick
		if $ThrowTether._stateless_condition(): return $ThrowTether
		if $TetherSwing._stateless_condition(): return $TetherSwing
		
	if current_state == $LedgeMount:
		if current_state.state_locked: return $LedgeMount
		if $Idle._stateless_condition(): return $Idle
		if $Run._stateless_condition(): return $Run
		if $Rise._stateless_condition(): return $Rise
		if $FallFromAir._stateless_condition(): return $FallFromAir
		
	if current_state == $GroundDash:
		if $FallFromGround._stateless_condition(): return $FallFromGround
		if $Superjump._stateless_condition(): return $Superjump		
		if current_state.state_locked: return $GroundDash
		if $GroundAttack1._stateless_condition(): return $GroundAttack1
		if $Idle._stateless_condition(): return $Idle
		if $Run._stateless_condition(): return $Run
		
	if current_state == $AirDash:
		if $LedgeMount._stateless_condition(): return $LedgeMount
		if $WallStick._stateless_condition(): return $WallStick
		if current_state.state_locked: return $AirDash
		if $Idle._stateless_condition(): return $Idle
		if $Run._stateless_condition(): return $Run
		if $FallFromAir._stateless_condition(): return $FallFromAir
		
	if current_state == $WallStick:
		if $Idle._stateless_condition(): return $Idle
		if $Run._stateless_condition(): return $Run
		if $AirDash._stateless_condition(): return $AirDash		
		if $WallRise._stateless_condition(): return $WallRise		
		if $WallStick._stateless_condition(): return $WallStick		
		if $FallFromWall._stateless_condition(): return $FallFromWall
		
	if current_state == $FallFromWall:
		if $LedgeMount._stateless_condition(): return $LedgeMount		
		if $Land._stateless_condition(): return $Land		
		if $Idle._stateless_condition(): return $Idle
		if $Run._stateless_condition(): return $Run
		if time_in_current_state <= coyote_time \
			and $WallRise._stateless_condition(): return $WallRise
		if $AirDash._stateless_condition(): return $AirDash
		if $WallStick._stateless_condition(): return $WallStick
		if $ThrowTether._stateless_condition(): return $ThrowTether
		if $TetherSwing._stateless_condition(): return $TetherSwing
		
	if current_state == $GroundAttack1:
		if current_state.state_locked: return current_state
		if $FallFromGround._stateless_condition(): return $FallFromGround		
		if $GroundAttack2._stateless_condition(): return $GroundAttack2
		if $Idle._stateless_condition(): return $Idle
		if $Run._stateless_condition(): return $Run
		if $Rise._stateless_condition(): return $Rise
		if $GroundDash._stateless_condition(): return $GroundDash
		
	if current_state == $GroundAttack2:
		if current_state.state_locked: return current_state
		if $FallFromGround._stateless_condition(): return $FallFromGround		
		if $GroundAttack3._stateless_condition(): return $GroundAttack3
		if $Idle._stateless_condition(): return $Idle
		if $Run._stateless_condition(): return $Run
		if $Rise._stateless_condition(): return $Rise
		if $GroundDash._stateless_condition(): return $GroundDash
	
	if current_state == $GroundAttack3:
		if current_state.state_locked: return current_state
		if $FallFromGround._stateless_condition(): return $FallFromGround		
		if $Idle._stateless_condition(): return $Idle
		if $Run._stateless_condition(): return $Run
		if $Rise._stateless_condition(): return $Rise
		if $GroundDash._stateless_condition(): return $GroundDash
		
	if current_state == $Land:
		if $Idle._stateless_condition(): return $Idle
		if $Run._stateless_condition(): return $Run
		if $Rise._stateless_condition(): return $Rise
		if $FallFromGround._stateless_condition(): return $FallFromGround
		if $GroundDash._stateless_condition(): return $GroundDash
		if $GroundAttack1._stateless_condition(): return $GroundAttack1
		
	if current_state == $ThrowTether:
		if current_state.state_locked: return current_state
		if $Rise._stateless_condition(): return $Rise
		if $FallFromAir._stateless_condition(): return $FallFromAir
		if $LedgeMount._stateless_condition(): return $LedgeMount
		if $AirDash._stateless_condition(): return $AirDash
		if $LedgeMount._stateless_condition(): return $LedgeMount		
		if $Land._stateless_condition(): return $Land		
		if $Idle._stateless_condition(): return $Idle
		if $Run._stateless_condition(): return $Run
		if $TetherSwing._stateless_condition(): return $TetherSwing
		
	if current_state == $TetherSwing:
		if current_state.state_locked: return current_state
		if $Rise._stateless_condition(): return $Rise
		if $FallFromAir._stateless_condition(): return $FallFromAir
		if $LedgeMount._stateless_condition(): return $LedgeMount
		if $AirDash._stateless_condition(): return $AirDash
		if $LedgeMount._stateless_condition(): return $LedgeMount		
		if $Land._stateless_condition(): return $Land		
		if $Idle._stateless_condition(): return $Idle
		if $Run._stateless_condition(): return $Run
		
	return current_state
	
func _set_face_dir_from_input():
	if Input.is_action_pressed("Left"):
		_set_face_dir(false)
	if Input.is_action_pressed("Right"):
		_set_face_dir(true)

func _set_face_dir(dir : bool):
	if (dir):
		is_facing_right = true
		BottomCast.target_position.x = cast_distance
		TopCast.target_position.x = cast_distance
		MiddleCast.target_position.x = cast_distance
		TetherCast.target_position.x = tether_distance
		PlayerSprite.scale.x = 1;
	else:
		is_facing_right = false
		BottomCast.target_position.x = -cast_distance
		TopCast.target_position.x = -cast_distance
		MiddleCast.target_position.x = -cast_distance
		TetherCast.target_position.x = -tether_distance
		PlayerSprite.scale.x = -1;
		
func _flip_face_dir():
	_set_face_dir(false) if is_facing_right else _set_face_dir(true)

func can_do_delayed_attack2():
	return last_attack_type == 1 and attack_timer < attack_delay_length
	
func can_do_delayed_attack3():
	return last_attack_type == 2 and attack_timer < attack_delay_length
	
func do_knockback():
	current_knockback = current_knockback.lerp(Vector2.ZERO, get_process_delta_time() * 18)
	Player.velocity += current_knockback
	
func apply_new_knockback():
	var dir_mod : int
	if is_facing_right: dir_mod = -1
	else: dir_mod = 1
	current_knockback.x = player_knockback_speed * dir_mod

func current_enemy_knockback():
	match last_attack_type:
		1:
			return attack1_enemy_knockback
		2:
			return attack2_enemy_knockback
		3: 
			return attack3_enemy_knockback
			
func force_walk_for_time(time):
	force_walk_timer = time
	
func force_input():
	if force_walk_timer <= 0: return
	var forced_input : Vector2 = Vector2.ZERO
	if is_facing_right: forced_input += Vector2.RIGHT
	else: forced_input += Vector2.LEFT
	input_dir = forced_input
	force_walk_timer -= get_process_delta_time()
