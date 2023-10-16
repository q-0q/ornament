extends CharacterBody2D

@onready var FSM : FSM = $FSM

	
func _physics_process(delta):
	move_and_slide()
	
func _process(delta):
	$debug_text.text = FSM.current_state.name


func _on_player_attack_hitbox_area_entered(area):
	print(area.name)

func _on_player_attack_hitbox_body_entered(body):
	if(body.is_in_group("hurtbox")):
		body.recieve_hit(2, FSM.current_enemy_knockback(), FSM.is_facing_right)
		HitstunManager.DO_HITSTUN.emit(0.1, get_tree())
		FSM.apply_new_knockback()
