extends Node

class_name ForceManager

var current_force : Vector2 = Vector2.ZERO
@onready var Character : CharacterBody2D = $".."

func do_force():
	current_force = current_force.lerp(Vector2.ZERO, 0.1)
	if (current_force.length() < 3): current_force = Vector2.ZERO
	Character.velocity += current_force
	
func apply_new_force(amt):
	var dir_mod : int
	if Util.player_fsm.is_facing_right: dir_mod = 1
	else: dir_mod = -1
	current_force.x = amt * dir_mod
