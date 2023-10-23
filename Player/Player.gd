extends CharacterBody2D

class_name Player

@onready var FSM : FSM = $FSM

var can_enter_doors : bool = true


func _ready():
	#Engine.time_scale = 0.25
	Util.player_fsm = FSM

func _physics_process(delta):
	move_and_slide()
	
func _process(delta):
	$debug_text.text = FSM.current_state.name
	Util._utils_update_player_positon(position)
